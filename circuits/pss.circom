pragma circom 2.1.8;
include "bigInt.circom";
include "utils.circom";
include "../node_modules/circomlib/circuits/sha256/sha256.circom";

function cdiv(a, b) {
    return (a + b - 1) \ b;
}

template Sha256Bytes(N) {
    signal input in[N];
    signal output out[32];

    signal bits[8 * N] <== Bytes2BitsLittle(N)(in);
    signal rev[8 * N] <== ReverseBitEndianness(N)(bits);
    signal hashBits[256] <== Sha256(8 * N)(rev);
    signal revHash[256] <== ReverseBitEndianness(32)(hashBits);
    out <== Bits2BytesLittle(32)(revHash);
}

template XorBits() {
    signal input a;
    signal input b;
    signal output out;
    out <== a + b - 2 * a * b;
}

template XorBytes() {
    signal input a;
    signal input b;
    signal output out;

    signal bits1[8] <== Num2Bits(8)(a);
    signal bits2[8] <== Num2Bits(8)(b);
    signal bits[8];
    var x = 0;
    for (var i = 0; i < 8; i++) {
        bits[i] <== XorBits()(bits1[i], bits2[i]);
        x += bits[i] * (1 << i);
    }
    out <== x;
}

template Concat(N, M) {
    signal input a[N];
    signal input b[M];
    signal output c[N + M];

    for (var i = 0; i < N + M; i++) {
        if (i < N)
            c[i] <== a[i];
        else
            c[i] <== b[i - N];
    }
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
                x += bytes[N - 1 - p] * (1 << (8 * j));
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
    if (N * BytesPerBlock >= xLen)
        sz = N * BytesPerBlock - xLen;
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
                bytes[xLen - 1 - ind] <== x;
            } else {
                zeros[zind] <== IsZero()(x);
                zind++;
            }
        }
    }

    for (var i = N * BytesPerBlock; i < xLen; i++)
        bytes[i] <== 0;

    assert (zind == sz);
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

// https://datatracker.ietf.org/doc/html/rfc8017#appendix-B.2.1
template MGF1(maskLen) {
    var hLen = 32;
    signal input mgfSeed[hLen];
    signal output T[maskLen];

    /*
    1.  If maskLen > 2^32 hLen, output "mask too long" and stop.
    */
    assert (maskLen <= (1 << 32) * hLen);

    /*
    2.  Let T be the empty octet string.
    */
    var index = 0;

    /*
    3.  For counter from 0 to \\ceil (maskLen / hLen) - 1, do the
        following:
    */
    var count = cdiv(maskLen, hLen);
    signal C[count][4];
    signal h[count][32];

    for (var counter = 0; counter < count; counter++) {
        /*
        A.  Convert counter to an octet string C of length 4 octets (see
            Section 4.1):
                C = I2OSP (counter, 4) .
        */
        for (var j = 0; j < 4; j++)
            C[counter][3 - j] <== (counter >> (8 * j)) & 255;

        /*
        B.  Concatenate the hash of the seed mgfSeed and C to the octet
            string T:
                T = T || Hash(mgfSeed || C) .
        */

        h[counter] <== Sha256Bytes(hLen + 4)(Concat(hLen, 4)(mgfSeed, C[counter]));
        for (var i = 0; i < 32; i++) {
            if(index < maskLen)
                T[index] <== h[counter][i];
            index++;
        }
    }
}

// https://datatracker.ietf.org/doc/html/rfc8017#section-9.1.2
template EMSA_PSS_VERIFY(mLen, BytesPerBlock, emBits, sLen) {
    var emLen = cdiv(emBits, 8);

    signal input M[mLen]; // bytes
    signal input EM[emLen]; // bytes

    signal output valid;

    var CHECKS = 5;
    signal check[CHECKS];

    /*
    1.  If the length of M is greater than the input limitation for
        the hash function (2^61 - 1 octets for SHA-1), output
        "inconsistent" and stop.
    */
    assert (8 * mLen <= (1 << 64) - 1); // probably some overflow can happen

    /*
    2.  Let mHash = Hash(M), an octet string of length hLen.
    */
    var hLen = 32;
    signal mHash[hLen] <== Sha256Bytes(mLen)(M);

    /*
    3.  If emLen < hLen + sLen + 2, output "inconsistent" and stop.
    */
    assert (emLen >= hLen + sLen + 2);

    /*
    4.  If the rightmost octet of EM does not have hexadecimal value
    0xbc, output "inconsistent" and stop.
    */
    check[0] <== IsEqual()([EM[emLen - 1], 0xbc]);

    /*
    5.  Let maskedDB be the leftmost emLen - hLen - 1 octets of EM,
        and let H be the next hLen octets.
    */

    var length = emLen - hLen - 1;
    signal maskedDB[length];
    for (var i = 0; i < length; i++)
        maskedDB[i] <== EM[i];

    signal H[hLen];
    for (var i = 0; i < hLen; i++)
        H[i] <== EM[length + i];

    /*
    6.  If the leftmost 8emLen - emBits bits of the leftmost octet in
        maskedDB are not all equal to zero, output "inconsistent" and
        stop.
    */
    signal maskedDBBits[8] <== Num2Bits(8)(maskedDB[0]);
    var x = 0;
    for (var i = 0; i < 8 * emLen - emBits; i++)
        x += maskedDBBits[7 - i];
    check[1] <== IsZero()(x);

    /*
    7.  Let dbMask = MGF(H, emLen - hLen - 1).
    */
    signal dbMask[length] <== MGF1(length)(H);

    /*
    8. Let DB = maskedDB \\xor dbMask.
    */
    signal DB[length];
    for (var i = 0; i < length; i++)
        DB[i] <== XorBytes()(maskedDB[i], dbMask[i]);

    /*
    9.  Set the leftmost 8emLen - emBits bits of the leftmost octet
        in DB to zero.
    */
    signal DB_[length];
    for (var i = 1; i < length; i++)
        DB_[i] <== DB[i];
    signal DBBits[8] <== Num2Bits(8)(DB[0]);
    var sum = 0;
    for (var i = 0; i < 8; i++) {
        var x = 0;
        if (i >= 8 * emLen - emBits) {
            x = DBBits[7 - i];
        }
        sum += x * (1 << (7 - i));
    }
    DB_[0] <== sum;

    /*
    10. If the emLen - hLen - sLen - 2 leftmost octets of DB are not
        zero or if the octet at position emLen - hLen - sLen - 1 (the
        leftmost position is "position 1") does not have hexadecimal
        value 0x01, output "inconsistent" and stop.
    */
    var length2 = emLen - hLen - sLen - 2;
    x = 0;
    for (var i = 0; i < length2; i++)
        x += DB_[i];
    check[2] <== IsZero()(x);
    check[3] <== IsEqual()([DB_[length2], 0x01]);

    /*
    11.  Let salt be the last sLen octets of DB.
    */
    signal salt[sLen];
    for (var i = 0; i < sLen; i++)
        salt[i] <== DB_[length - sLen + i];

    /*
    12. Let
            M' = (0x)00 00 00 00 00 00 00 00 || mHash || salt ;
        M' is an octet string of length 8 + hLen + sLen with eight
        initial zero octets.
    */
    signal M_[8 + hLen + sLen];
    for (var i = 0; i < 8; i++)
        M_[i] <== 0;
    for (var i = 0; i < hLen; i++)
        M_[8 + i] <== mHash[i];
    for (var i = 0; i < sLen; i++)
        M_[8 + hLen + i] <== salt[i];

    /*
    13.  Let H' = Hash(M'), an octet string of length hLen.
    */
    signal H_[32] <== Sha256Bytes(8 + hLen + sLen)(M_);

    /*
    14. If H = H', output "consistent".  Otherwise, output
        "inconsistent".
    */

    check[4] <== long_equals(32)(H, H_);

    valid <== all(CHECKS)(check);
}

// https://datatracker.ietf.org/doc/html/rfc8017#section-8.1.2
// all the inputs are in bytes
template RSASSA_PSS_VERIFY(messageBytes, modBits, e, sLen) {
    var keyBytes = cdiv(modBits, 8);
    signal input P[keyBytes]; // stands for a public key, not a prime number
    signal input M[messageBytes];
    signal input S[keyBytes];

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

    var BytesPerBlock = 12; // maybe 10 ?
    var K = cdiv(keyBytes, BytesPerBlock);
    signal s[K] <== OS2IP(keyBytes, BytesPerBlock)(S);
    signal p[K] <== OS2IP(keyBytes, BytesPerBlock)(P);

    var CHECKS = 3;
    signal check[CHECKS];

    signal m[K];
    (check[0], m) <== RSAVP1(K, BytesPerBlock, e)(p, s);

    var emLen = cdiv(modBits - 1, 8);
    signal EM[emLen];
    (check[1], EM) <== I2OSP(K, BytesPerBlock, emLen)(m);

    /*
    3.  EMSA-PSS verification: Apply the EMSA-PSS verification
        operation (Section 9.1.2) to the message M and the encoded
        message EM to determine whether they are consistent:
                Result = EMSA-PSS-VERIFY (M, EM, modBits - 1).
    */
    check[2] <== EMSA_PSS_VERIFY(messageBytes, BytesPerBlock, modBits - 1, sLen)(M, EM);

    out <== all(CHECKS)(check);
}
