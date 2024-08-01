pragma circom 2.1.8;
template AddressFromPK() {
    signal input pk[2][4];
    signal output address; // 160-bit integer

    // TODO
    address <== 0;
}

template CheckInclusionProof(levels) {
    signal input pk[2][4];
    signal input proof[levels];
    signal input path[levels];

    signal output out;

    signal address <== AddressFromPK()(pk);
    // TODO
    out <== 1;
}

