pragma circom 2.1.8;

template verify(levels) {
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

    out <== 1;
}

component main {public [root]} = verify(4);

