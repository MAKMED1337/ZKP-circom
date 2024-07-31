template AddressFromPK() {
    signal input pk[2][2];
    signal output address; // 160-bit integer

    // TODO
    address <== 0;
}

template CheckInclusionProof(levels) {
    signal input pk[2][2];
    signal input proof[levels];
    signal input path[levels];

    signal output out;

    signal address <== AddressFromPK()(pk);
    // TODO
    out <== 1;
}

