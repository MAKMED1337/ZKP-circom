pragma circom 2.1.9;
include "bigInt.circom";
include "utils.circom";

template check_signature(K, B, e) {
    signal input n[K];
    signal input m[K];
    signal input s[K];

    signal output isVerified;

    signal n_check <== check_fit(K, B)(n);
    signal m_check <== check_fit(K, B)(m);
    signal s_check <== check_fit(K, B)(s);

    signal x[K] <== power(K, B, e)(s, n);
    signal signature_check <== long_equals(K)(x, m);

    isVerified <== all(4)([n_check, m_check, s_check, signature_check]);
}

// 8*64 = 512-bit
component main {public [n]} = check_signature(8, 64, 65537);
