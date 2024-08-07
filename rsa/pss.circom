pragma circom 2.1.9;
include "bigInt.circom";
include "utils.circom";

function cdiv(a, b) {
    return (a + b - 1) \ b;
}

// https://datatracker.ietf.org/doc/html/rfc8017#section-4.2
// instead of the integer this function returns an inner representation
template OS2IP(N, BytesPerBlock) {
    var blocks = cdiv(N, BytesPerBlock);

    signal input bytes[N];
    signal output inner[blocks];

    for (var i = 0; i < blocks; i++) {
        var x = 0;
        for (var j = 0; j < BytesPerBlock; j++) {
            var p = i * BytesPerBlock + j;
            if(p < N) {
                x += bytes[N - 1 - p] * (1 << j);
            }
        }
        inner[i] <== x;
    }
}

// https://datatracker.ietf.org/doc/html/rfc8017#section-4.2
template I2OSP(N, BytesPerBlock, xLen) {
    signal input inner[N];

    signal output valid;
    signal output bytes[xLen];

    signal bits[N][8 * BytesPerBlock];

    var sz = 0;
    if (8 * BytesPerBlock >= xLen)
        sz = 8 * BytesPerBlock - xLen;
    signal zeros[sz];
    var zind = 0;

    for (var i = 0; i < N; i++) {
        bits[i] <== Num2Bits(8 * BytesPerBlock)(inner[i]);
        for (var j = 0; j < BytesPerBlock; j++) {
            var x = 0;
            for (var k = 0; k < 8; k++) {
                x += (bits[i][8 * j + k]) * (1 << k);
            }

            var ind = i * BytesPerBlock + j;
            if (ind < xLen) {
                bytes[ind] <== x;
            } else {
                zeros[zind] <== IsZero()(x);
            }
        }
    }

    for (var i = 8 * BytesPerBlock; i < xLen; i++)
        bytes[i] <== 0;

    valid <== all(zind)(zeros);
}

// https://datatracker.ietf.org/doc/html/rfc8017#section-5.2.2
template RSAVP1(K, BytesPerBlock, e) {
    signal input n[K];
    signal input s[K];

    signal output valid;
    signal output m[K];

    var B = 8 * BytesPerBlock;
    valid <== is_less(K, B)(s, n);
    m <== power(K, B, e)(s, n);
}

template EMSA_PSS_VERIFY(N, BytesPerBlock, emBits, sLen) {
    var emLen = cdiv(emBits, 8);

    signal input M[N]; // bytes
    signal input EM[emLen]; // bytes

    signal output valid;

    assert(false); // TODO

    valid <== 1;
}

// https://datatracker.ietf.org/doc/html/rfc8017#section-8.1.2
// all the inputs are in bytes
template RSASSA_PSS_VERIFY(N, modBits, e, sLen) {
    signal input P[N]; // stands for a public key, not a prime number
    signal input M[N];
    signal input S[N];

    signal output out;

    /*
    1.  Length checking: If the length of the signature S is not k
        octets, output "invalid signature" and stop.
    */

    // ignore, because of the representation

    /*
    2.  RSA verification:
          a.  Convert the signature S to an integer signature
              representative s (see Section 4.2):
                 s = OS2IP (S).
          b.  Apply the RSAVP1 verification primitive (Section 5.2.2) to
              the RSA public key (n, e) and the signature representative
              s to produce an integer message representative m:
                 m = RSAVP1 ((n, e), s).
              If RSAVP1 output "signature representative out of range",
              output "invalid signature" and stop.
          c.  Convert the message representative m to an encoded message
              EM of length emLen = \\ceil ((modBits - 1)/8) octets, where
              modBits is the length in bits of the RSA modulus n (see
              Section 4.1):
                 EM = I2OSP (m, emLen).
              Note that emLen will be one less than k if modBits - 1 is
              divisible by 8 and equal to k otherwise.  If I2OSP outputs
              "integer too large", output "invalid signature" and stop.
    */

    var BytesPerBlock = 8; // maybe 10 ?
    var K = cdiv(N, BytesPerBlock);
    signal s[K] <== OS2IP(N, BytesPerBlock)(S);
    signal p[K] <== OS2IP(N, BytesPerBlock)(P);

    var CHECKS = 3;
    signal check[CHECKS];

    signal m[K];
    (check[0], m) <== RSAVP1(K, BytesPerBlock, e)(s, p);

    var emLen = cdiv(modBits - 1, 8);
    signal EM[emLen];
    (check[1], EM) <== I2OSP(K, BytesPerBlock, emLen)(m);

    /*
    3.  EMSA-PSS verification: Apply the EMSA-PSS verification
        operation (Section 9.1.2) to the message M and the encoded
        message EM to determine whether they are consistent:
                Result = EMSA-PSS-VERIFY (M, EM, modBits - 1).
    */
    check[2] <== EMSA_PSS_VERIFY(N, BytesPerBlock, modBits - 1, sLen)(M, EM);

    out <== all(CHECKS)(check);
}
