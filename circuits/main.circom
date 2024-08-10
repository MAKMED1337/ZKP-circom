pragma circom 2.1.8;
include "bigInt.circom";
include "utils.circom";
include "pss.circom";

template checkHighestBit(modBits) {
    var keyBytes = cdiv(modBits, 8);
    signal input n[keyBytes];
    signal output out;

    signal bits[8] <== Num2Bits(8)(n[0]);
    var x = 0;
    for (var i = 0; i < 8 * keyBytes - modBits; i++)
        x += bits[7 - i];
    out <== IsZero()(x);
}

// big endian
template CheckSignature(messageBytes, modBits, e, sLen) {
    var keyBytes = cdiv(modBits, 8);
    signal input n[keyBytes];
    signal input m[messageBytes];
    signal input s[keyBytes];

    signal output isVerified;

    signal nCheck <== check_fit(keyBytes, 8)(n);
    signal mCheck <== check_fit(messageBytes, 8)(m);
    signal sCheck <== check_fit(keyBytes, 8)(s);

    signal modBitsCheck <== checkHighestBit(modBits)(n);

    signal signatureCheck <== RSASSA_PSS_VERIFY(messageBytes, modBits, e, sLen)(n, m, s);

    isVerified <== all(5)([nCheck, mCheck, sCheck, modBitsCheck, signatureCheck]);
}

component main {public [n]} = CheckSignature(32, 512, 65537, 0);
