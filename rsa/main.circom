pragma circom 2.1.9;
include "bigInt.circom";
include "utils.circom";
include "pss.circom";

template CheckSignature(messageBytes, modBits, e, sLen) {
    var keyBytes = cdiv(modBits, 8);
    signal input n[keyBytes];

    signal input m[messageBytes];
    signal input s[keyBytes];

    signal output isVerified;

    signal nCheck <== check_fit(keyBytes, 8)(n);
    signal mCheck <== check_fit(messageBytes, 8)(m);
    signal sCheck <== check_fit(keyBytes, 8)(s);

    signal nBits[8 * keyBytes] <== Bytes2Bits(keyBytes)(n);
    signal highestBit <== get_highest_index_non_zero(8 * keyBytes, 1)(nBits);
    signal modBitsCheck <== IsEqual()([highestBit, modBits - 1]);

    signal signatureCheck <== RSASSA_PSS_VERIFY(messageBytes, modBits, e, sLen)(n, m, s);

    isVerified <== all(5)([nCheck, mCheck, sCheck, modBitsCheck, signatureCheck]);
}

component main {public [n]} = CheckSignature(32, 512, 65537, 0);
