pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

template all(N) {
    signal input in[N];
    signal output out;

    var x = 0;
    for (var i = 0; i < N; i++)
        x += in[i];

    out <== IsEqual()([x, N]);
}

template Bytes2BitsLittle(N) {
    signal input in[N];
    signal output out[8 * N];

    signal bits[N][8];
    for (var i = 0; i < N; i++) {
        bits[i] <== Num2Bits(8)(in[i]);
        for (var j = 0; j < 8; j++) {
            out[8 * i + j] <== bits[i][j];
        }
    }
}

template Bits2BytesLittle(N) {
    signal input in[8 * N];
    signal output out[N];

    for (var i = 0; i < N; i++) {
        var x = 0;
        for (var j = 0; j < 8; j++)
            x += in[8 * i + j] * (1 << j);
        out[i] <== x;
    }
}

template ReverseBitEndianness(N) {
    signal input in[8 * N];
    signal output out[8 * N];
    for (var i = 0; i < N; i++)
        for (var j = 0; j < 8; j++)
            out[8 * i + 7 - j] <== in[8 * i + j];
}

