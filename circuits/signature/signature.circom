pragma circom 2.1.8;
include "../helper.circom";
include "../circom-ecdsa/ecdsa.circom";

template CheckSignature() {
    // 4x64 bits each
    signal input r[4];
    signal input s[4];
    // x, y, 4x64 bits each
    signal input pk[2][4];

    signal input msgHash[4];

    signal output out;

    var CHECKS = 6;
    signal check[CHECKS];
    check[0] <== CheckRepr()(r);
    check[1] <== CheckRepr()(s);
    check[2] <== CheckRepr()(pk[0]);
    check[3] <== CheckRepr()(pk[1]);
    check[4] <== CheckRepr()(msgHash);
    // TODO, check if pk is valid
    check[5] <== ECDSAVerifyNoPubkeyCheck(64, 4)(r, s, msgHash, pk);

    out <== All(CHECKS)(check);
}
