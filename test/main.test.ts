import { CheckKeyAndInclusion, CheckSignature } from "@/generated-types/zkit";
import { expect } from "chai";
import { zkit } from "hardhat";
import { encode256, r, s, pk, msgHash, addresses } from "./helper";
import { build_tree } from "./merkle_tree.test";

let mainCircuit: CheckKeyAndInclusion;
let path: bigint[];
let proof: bigint[];
let root: bigint;

before("setup", async () => {
    mainCircuit = await zkit.getCircuit("CheckKeyAndInclusion");
    [path, proof, root] = build_tree(4, 5, addresses);
});

it("check a valid", async () => {
    const proofStruct = await mainCircuit.generateProof({
        root,
        r: encode256(r),
        s: encode256(s),
        pk: [encode256(pk[0]), encode256(pk[1])],
        msgHash: encode256(msgHash),
        proof,
        path,
    });

    expect(proofStruct.publicSignals.out).to.equal(
        "1"
    )
});

it("check an invalid signature", async () => {
    const proofStruct = await mainCircuit.generateProof({
        root,
        r: encode256(r + 1n),
        s: encode256(s),
        pk: [encode256(pk[0]), encode256(pk[1])],
        msgHash: encode256(msgHash),
        proof,
        path,
    });

    expect(proofStruct.publicSignals.out).to.equal(
        "0"
    )
});

it("check an invalid proof", async () => {
    let invalid_path = [...path];
    invalid_path[0] = BigInt(invalid_path[0]) ^ 1n;
    const proofStruct = await mainCircuit.generateProof({
        root,
        r: encode256(r),
        s: encode256(s),
        pk: [encode256(pk[0]), encode256(pk[1])],
        msgHash: encode256(msgHash),
        proof,
        path: invalid_path,
    });

    expect(proofStruct.publicSignals.out).to.equal(
        "0"
    )
});

