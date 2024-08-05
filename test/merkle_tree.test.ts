import { BuildMerkleTree, CheckInclusionProof } from "@/generated-types/zkit";
import { expect } from "chai";
import { zkit } from "hardhat";
import { encode256, pk, address, addresses } from "./helper";

// using an old version, because: https://github.com/iden3/circomlibjs/issues/14
// @ts-ignore
import { poseidon } from "circomlibjs";
import assert from "assert";
import { ethers } from "ethers";

let lrhash = (l: bigint, r: bigint) => ethers.toBigInt(poseidon([l, r], 0, 1));
export function build_tree(levels: number, index: number, leaves: bigint[]): [bigint[], bigint[], bigint] {
    let totalLeaves = 1 << levels;
    assert(leaves.length == totalLeaves);

    // The number of HashLeftRight components which will be used to hash the
    // leaves
    let numLeafHashers = totalLeaves / 2;

    // The number of HashLeftRight components which will be used to hash the
    // output of the leaf hasher components
    let numIntermediateHashers = numLeafHashers - 1;

    let path: bigint[] = [];
    let proof: bigint[] = [];
    let root: bigint;

    // The total number of hashers
    let numHashers = totalLeaves - 1;
    let hashers = Array(numHashers);

    // Wire the leaf values into the leaf hashers
    for (let i = 0; i < numLeafHashers; i++) {
        hashers[i] = lrhash(leaves[i * 2], leaves[i * 2 + 1]);
    }
    proof.push(leaves[index ^ 1]);
    path.push(BigInt(index & 1));
    index = index >> 1;

    // Wire the outputs of the leaf hashers to the intermediate hasher inputs
    let k = 0;
    for (let i = numLeafHashers; i < numLeafHashers + numIntermediateHashers; i++) {
        hashers[i] = lrhash(hashers[k * 2], hashers[k * 2 + 1]);

        if (k * 2 == index) {
            proof.push(hashers[k * 2 + 1]);
            path.push(0n);
            index = i;
        }
        if (k * 2 + 1 == index) {
            proof.push(hashers[k * 2]);
            path.push(1n);
            index = i;
        }

        k++;
    }

    root = hashers[numHashers - 1];
    return [path, proof, root];
}

let builderCircuit: BuildMerkleTree;
let mainCircuit: CheckInclusionProof;
let path: bigint[];
let proof: bigint[];
let root: bigint;

before("setup", async () => {
    builderCircuit = await zkit.getCircuit("BuildMerkleTree");
    mainCircuit = await zkit.getCircuit("CheckInclusionProof");

    expect(addresses[5]).to.equal(address);
    [path, proof, root] = build_tree(4, 5, addresses);
});

it("check building of a merkle tree", async () => {
    const proofStruct = await builderCircuit.generateProof({
        leaves: addresses
    });

    expect(proofStruct.publicSignals.root).to.equal(root.toString());
});

it("check a valid merkle tree", async () => {
    const proofStruct = await mainCircuit.generateProof({
        proof, path, root,
        pk: [encode256(pk[0]), encode256(pk[1])],
    });

    expect(proofStruct.publicSignals.out).to.equal("1");
});

it("check an invalid root", async () => {
    const proofStruct = await mainCircuit.generateProof({
        proof, path,
        root: BigInt(root) + 1n,
        pk: [encode256(pk[0]), encode256(pk[1])],
    });

    expect(proofStruct.publicSignals.out).to.equal("0");
});

it("check an invalid path", async () => {
    let invalid_path = [...path];
    invalid_path[0] = BigInt(invalid_path[0]) ^ 1n;
    const proofStruct = await mainCircuit.generateProof({
        proof, root,
        path: invalid_path,
        pk: [encode256(pk[0]), encode256(pk[1])],
    });

    expect(proofStruct.publicSignals.out).to.equal("0");
});

it("check an invalid proof", async () => {
    let invalid_proof = [...proof];
    invalid_proof[0] = BigInt(invalid_proof[0]) ^ 1n;
    const proofStruct = await mainCircuit.generateProof({
        root, path,
        proof: invalid_proof,
        pk: [encode256(pk[0]), encode256(pk[1])],
    });

    expect(proofStruct.publicSignals.out).to.equal("0");
});
