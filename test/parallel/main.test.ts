import { CheckSignature } from "@/generated-types/zkit";
import { zkit } from "hardhat";
import { expect } from "chai"; // chai-zkit extension
import base64url from "base64url";
import assert from "assert";

let circuit: CheckSignature;
const subtle = crypto.subtle;
let key_pair: CryptoKeyPair;
let n: Uint8Array;

const message = new Uint8Array(32);
message[0] = 42;

before("setup", async () => {
    circuit = await zkit.getCircuit("CheckSignature");
    key_pair = await subtle.generateKey(
        {
            name: 'RSA-PSS',
            modulusLength: 512,
            publicExponent: new Uint8Array([1, 0, 1]),
            hash: "SHA-384",
        },
        true,
        ['sign', 'verify']
    );

    const jwk = await subtle.exportKey('jwk', key_pair.privateKey);
    assert(jwk.n);
    n = base64url.toBuffer(jwk.n); // big endian
    assert(n[0] & 128); // pk should have 512 bits
});

it("Check a valid RSA PSS", async () => {
    let signature = await subtle.sign({ name: 'RSA-PSS', saltLength: 0 }, key_pair.privateKey, message);

    await expect(circuit)
        .with.witnessInputs({
            n: Array.from(n),
            m: Array.from(message),
            s: Array.from(new Uint8Array(signature)),
        }).to.have.witnessOutputs({
            isVerified: 1n,
        });
});

it("Check an invalid message RSA PSS", async () => {
    let signature = await subtle.sign({ name: 'RSA-PSS', saltLength: 0 }, key_pair.privateKey, message);
    let msg = new Uint8Array(message);
    msg[0] ^= 1;

    await expect(circuit)
        .with.witnessInputs({
            n: Array.from(n),
            m: Array.from(msg),
            s: Array.from(new Uint8Array(signature)),
        }).to.have.witnessOutputs({
            isVerified: 0n,
        });
});

it("Check an invalid signature RSA PSS", async () => {
    let signature = await subtle.sign({ name: 'RSA-PSS', saltLength: 0 }, key_pair.privateKey, message);
    let msg = new Uint8Array(message);
    let sig = new Uint8Array(signature);
    sig[0] ^= 1;

    await expect(circuit)
        .with.witnessInputs({
            n: Array.from(n),
            m: Array.from(msg),
            s: Array.from(sig),
        }).to.have.witnessOutputs({
            isVerified: 0n,
        });
});
