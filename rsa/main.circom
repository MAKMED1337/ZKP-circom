pragma circom 2.1.9;
include "bigInt.circom";
include "utils.circom";
include "pss.circom";

template Bytes2Bits(N) {
    signal input a[N];
    signal output out[8 * N];

    signal bits[N][8];
    for (var i = 0; i < N; i++) {
        bits[i] <== Num2Bits(8)(a[i]);
        for (var j = 0; j < 8; j++) {
            out[8 * i + j] <== bits[i][j];
        }
    }
}

template CheckSignature(Bytes, ModBits, e, sLen) {
    signal input n[Bytes];
    signal input m[Bytes];
    signal input s[Bytes];

    signal output isVerified;

    signal nCheck <== check_fit(Bytes, 8)(n);
    signal mCheck <== check_fit(Bytes, 8)(m);
    signal sCheck <== check_fit(Bytes, 8)(s);

    signal nBits[8 * Bytes] <== Bytes2Bits(Bytes)(n);
    signal highestBit <== get_highest_index_non_zero(8 * Bytes, 1)(nBits);
    signal modBitsCheck <== IsEqual()([highestBit, ModBits - 1]);

    signal signatureCheck <== RSASSA_PSS_VERIFY(Bytes, ModBits, e, sLen)(n, m, s);

    isVerified <== all(5)([nCheck, mCheck, sCheck, modBitsCheck, signatureCheck]);
}

// 64 * 8 = 512-bit
component main {public [n]} = CheckSignature(64, 512, 65537, 20);
