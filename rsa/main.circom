pragma circom 2.1.9;
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/binsum.circom";

template all(N) {
    signal input in[N];
    signal output out;

    var x = 0;
    for (var i = 0; i < N; i++)
        x += in[i];

    out <== IsEqual()([x, N]);
}

template check_fit(N, B) {
    signal input in[N];
    signal output out;

    signal is_valid[N];
    for (var i = 0; i < N; i++) {
        // use 252, so the user can pass a bad input, and only then get false
        is_valid[i] <== LessThan(252)([in[i], 1 << B]);
    }

    out <== all(N)(is_valid);
}

function calc_max_bits(K, B) {
    var i = 0;
    while((1 << i) < K)
        i++;

    return 2 * B * i;
}

template mult(K, B) {
    signal input a[K];
    signal input b[K];
    signal output out[2 * K];

    signal mult_by_block[K][2 * K];
    for (var i = 0; i < K; i++) {// i-th block
        for (var j = 0; j < 2 * K; j++) {
            if (j < i || j - i >= K) // region near the shifted value bits
                mult_by_block[i][j] <== 0;
            else
                mult_by_block[i][j] <== a[i] * b[j - i];
        }
    }

    signal temp[2 * K];
    // calculate res for k, as: res[k] = sum(a[i] * b[k - i])
    // max value per temp is (2 ** B - 1)**2 * (K + 1)

    for (var i = 0; i < 2 * K; i++) {
        var x = 0;
        for (var j = 0; j <= i; j++) {
            if (j < K && i - j >= 0 && i - j < K)
                x += mult_by_block[j][i - j];
        }
        temp[i] <== x;
    }

    // normalize each res[k], so it has less then B bits
    var carry = 0;
    var max_bits = calc_max_bits(K, B);
    signal bits[2 * K][max_bits];
    signal truncated_bits[2 * K][B];

    for (var i = 0; i < 2 * K; i++) {
        bits[i] <== Num2Bits(max_bits)(temp[i] + carry); // impilicit assertion about overflow
        for (var j = 0; j < B; j++)
            truncated_bits[i][j] <== bits[i][j];
        out[i] <== Bits2Num(B)(truncated_bits[i]);

        carry = 0;
        var pw = 1;
        for (var j = B; j < max_bits; j++) {
            carry += bits[i][j] * pw;
            pw *= 2;
        }
    }
}

template bin(N, X) {
    signal output out[N];
    for (var i = 0; i < N; i++)
        out[i] <== (X >> i) & 1;
}

template if_else(N) {
    signal input if_[N];
    signal input else_[N];
    signal input cond;
    signal output out[N];

    for (var i = 0; i < N; i++)
        out[i] <== cond * (if_[i] - else_[i]) + else_[i];
}

template if_mod(N) {
    signal input a[N + 1];
    signal input mod[N];
    signal output out[N];

    signal tmp[N];
    signal diff[N];
    signal minus_1[N];
    signal minus_2[N];
    var carry = 0;
    for (var i = 0; i < N; i++) {
        tmp[i] <== a[i] - mod[i] - carry;
        // tmp = 0 or tmp = 1 - OK => diff = tmp, carry = 0
        // tmp = -1 or tmp = -2 - then we need to take 1 from the next bit => diff = 2 + tmp, carry = 1

        minus_1[i] <== IsEqual()([tmp[i], -1]);
        minus_2[i] <== IsEqual()([tmp[i], -2]);
        carry = minus_1[i] + minus_2[i];

        diff[i] <== 2 * carry + tmp[i];
    }

    // a[N] can't be greater then carry, because if so, then a[N] - mod >= 2^N > mod
    // if a[N] = carry, then we can subtract (a >= mod), else we can't (a < mod)
    signal equal <== IsEqual()([a[N] - carry, 0]);

    signal strip[N];
    for (var i = 0; i < N; i++)
        strip[i] <== a[i];

    out <== if_else(N)(diff, strip, equal);
}

template take_mod_bin(N, M) {
    signal input a[M];
    signal input mod[N];
    signal output out[N];

    signal sliding_window[M + 1][N]; // slidining_window[i] = (a[i..N] as a number) % mod
    signal sliding_window_unmod[M + 1][N + 1];
    sliding_window[M] <== bin(N, 0)();

    for (var i = M - 1; i >= 0; i--) {
        // when we are sliding to the left, we are concatinating one digit to the right
        // so the new value <= 2 * (previous value) + 1 <= 2 * (mod - 1) + 1 = 2 mod - 1
        // so we need to take mod only 1 time

        sliding_window_unmod[i][0] <== a[i];
        for (var j = 0; j < N; j++)
            sliding_window_unmod[i][j + 1] <== sliding_window[i + 1][j];

        sliding_window[i] <== if_mod(N)(sliding_window_unmod[i], mod);
    }

    out <== sliding_window[0];
}

template block_to_bin(K, B) {
    var N = K * B;
    signal input a[K];
    signal output out[N];

    signal bin[K][B];
    for (var i = 0; i < K; i++) {
        bin[i] <== Num2Bits(B)(a[i]);
        for (var j = 0; j < B; j++)
            out[i * B + j] <== bin[i][j];
    }
}

template bin_to_block(K, B) {
    var N = K * B;
    signal input a[N];
    signal output out[K];

    for (var i = 0; i < K; i++) {
        var x = 0;
        var pw = 1;
        for (var j = 0; j < B; j++) {
            x += a[i] * pw;
            pw *= 2;
        }
        out[i] <== x;
    }
}

template mult_mod(K, B) {
    signal input a[K];
    signal input b[K];
    signal input mod[K];
    signal output out[K];

    signal mod_bin[K * B] <== block_to_bin(K, B)(mod);

    signal res[2 * K] <== mult(K, B)(a, b);
    signal res_bin[2 * K * B] <== block_to_bin(2 * K, B)(res);

    signal out_bin[K * B] <== take_mod_bin(K * B, 2 * K * B)(res_bin, mod_bin);
    out <== bin_to_block(K, B)(out_bin);
}

template power(K, B) {
    signal input a[K];
    signal input b[K];
    signal input mod[K];
    signal output out[K];

    var N = K * B;
    signal bin_b[N] <== block_to_bin(K, B)(b);

    // 1-index
    signal exp[N + 2][K];
    signal res[N + 1][K]; // result, if b[i] = 1, and previous bits are correct
    signal res_if_1[N + 1][K];

    res[0] <== bin(K, 1)(); // not the bin, but ok
    exp[1] <== a;
    for (var i = 1; i <= N; i++) {
        res_if_1[i] <== mult_mod(K, B)(res[i - 1], exp[i], mod);

        var bit = bin_b[i - 1]; // because of the offset
        res[i] <== if_else(K)(res_if_1[i], res[i - 1], bit);

        exp[i + 1] <== mult_mod(K, B)(exp[i], exp[i], mod);
    }

    out <== res[N];
}

template LongEqual(N) {
    signal input a[N];
    signal input b[N];
    signal output out;

    signal same[N];
    for (var i = 0; i < N; i++)
        same[i] <== IsEqual()([a[i], b[i]]);
    out <== all(N)(same);
}

template check_signature(K, B) {
    assert (K < 250); // to not overflow circom's numbers
    signal input n[K];
    signal input e[K];
    signal input m[K];
    signal input s[K];

    signal output isVerified;

    signal n_check <== check_fit(K, B)(n);
    signal e_check <== check_fit(K, B)(e);
    signal m_check <== check_fit(K, B)(m);
    signal s_check <== check_fit(K, B)(s);

    signal x[K] <== power(K, B)(s, e, n);
    signal signature_check <== LongEqual(K)(x, m);
    isVerified <== all(5)([n_check, e_check, m_check, s_check, signature_check]);
}

// 8*8 = 64-bit, takes 20GB of RAM, and 2-3 mins to compile
component main {public [n, e]} = check_signature(8, 8);
