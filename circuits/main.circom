pragma circom 2.1.8;
include "circomlib/circuits/comparators.circom";
include "merkleTree.circom";

template All(N) {
    signal input in[N];
    signal output out;

    var x = 0;
    for (var i = 0; i < N; i++)
        x += in[i];

    out <== IsEqual()([x, N]);
}

template LessThanPower2(N) {
    assert(N <= 253);

    signal input in;
    signal output out;

    var pw = 1, value = 0;
    signal bits[N];
    for (var i = 0; i < N; i++) {
        bits[i] <-- (in >> i) & 1;
        bits[i] * (bits[i] - 1) === 0;
        value += bits[i] * pw;
        pw *= 2;
    }

    out <== IsEqual()([in, value]);
}

// 256 bit representation is 2 x 128 bits
template CheckRepr() {
    signal input in[2];
    signal output out;

    signal first <== LessThanPower2(128)(in[0]);
    signal second <== LessThanPower2(128)(in[0]);

    out <== first * second;
}

template CheckSignature() {
    // 128 bits each
    signal input r[2];
    signal input s[2];
    // x, y, 128 bits each
    signal input pk[2][2];

    signal output out;

    var CHECKS = 4;
    signal check[CHECKS];
    check[0] <== CheckRepr()(r);
    check[1] <== CheckRepr()(s);
    check[2] <== CheckRepr()(pk[0]);
    check[3] <== CheckRepr()(pk[1]);

    // TODO
    out <== All(CHECKS)(check);
}

template CheckKeyAndInclusion(levels) {
    signal input root;

    // 128 bits each
    signal input r[2];
    signal input s[2];
    // x, y, 128 bits each
    signal input pk[2][2];

    // inclusion proof, path is {0 = left, 1 = right}
    signal input proof[levels];
    signal input path[levels];

    signal output out;

    signal isSignatureCorrect <== CheckSignature()(r, s, pk);
    signal isProofCorrect <== CheckInclusionProof(levels)(pk, proof, path);

    out <== isSignatureCorrect * isProofCorrect;
}

component main {public [root]} = CheckKeyAndInclusion(4);

