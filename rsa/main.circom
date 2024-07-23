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

template check_binary(N) {
    signal input in[N];
    signal output out;

    signal last_bit[N];
    signal is_valid[N];
    for (var i = 0; i < N; i++) {
        last_bit[i] <-- in[i] & 1;
        last_bit[i] * (last_bit[i] - 1) === 0;
        is_valid[i] <== IsEqual()([in[i], last_bit[i]]);
    }

    out <== all(N)(is_valid);
}

template mult(N) {
    signal input a[N];
    signal input b[N];
    signal output out[2 * N];

    signal mult_by_bit[N][2 * N];
    for (var i = 0; i < N; i++) {// i-th bit
        for (var j = 0; j < 2 * N; j++) {
            if (j < i || j - i >= N) // region near the shifted value bits
                mult_by_bit[i][j] <== 0;
            else
                mult_by_bit[i][j] <== a[i] * b[j - i];
        }
    }

    var Nout = nbits((2 ** (2 * N) - 1) * N);
    signal t[Nout] <== BinSum(2 * N, N)(mult_by_bit);

    // multiplication of two numbers, that are < 2^n, will give us res = a * b < (2^n)*(2^n) = 2^(2n)
    // so, we can truncate it
    for (var i = 0; i < 2 * N; i++)
        out[i] <== t[i];
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

template take_mod(N, M) {
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

template mult_mod(N) {
    signal input a[N];
    signal input b[N];
    signal input mod[N];
    signal output out[N];

    signal res[2 * N] <== mult(N)(a, b);
    out <== take_mod(N, 2 * N)(res, mod);
}

template power(N) {
    signal input a[N];
    signal input b[N];
    signal input mod[N];
    signal output out[N];

    // 1-index
    signal exp[N + 2][N];
    signal res[N + 1][N]; // result, if b[i] = 1, and previous bits are correct
    signal res_if_1[N + 1][N];

    res[0] <== bin(N, 1)();
    exp[1] <== a;
    for (var i = 1; i <= N; i++) {
        res_if_1[i] <== mult_mod(N)(res[i - 1], exp[i], mod);

        var bit = b[i - 1]; // because of the offset
        res[i] <== if_else(N)(res_if_1[i], res[i - 1], bit);

        exp[i + 1] <== mult_mod(N)(exp[i], exp[i], mod);
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

template check_signature(N) {
    signal input n[N];
    signal input e[N];
    signal input m[N];
    signal input s[N];

    signal output isVerified;

    signal n_check <== check_binary(N)(n);
    signal e_check <== check_binary(N)(e);
    signal m_check <== check_binary(N)(m);
    signal s_check <== check_binary(N)(s);

    signal x[N] <== power(N)(s, e, n);
    signal signature_check <== LongEqual(N)(x, m);
    isVerified <== all(5)([n_check, e_check, m_check, s_check, signature_check]);
}

component main {public [n, e]} = check_signature(4);
