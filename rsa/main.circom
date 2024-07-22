pragma circom 2.1.9;
include "../node_modules/circomlib/circuits/comparators.circom";

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

    isVerified <== all(4)([n_check, e_check, m_check, s_check]);
}

component main {public [n, e]} = check_signature(2);
