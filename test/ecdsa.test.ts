import { CheckKeyAndInclusion, CheckSignature } from "@/generated-types/zkit";
import { expect } from "chai";
import { zkit } from "hardhat";
import { encode256, r, s, pk, msgHash } from "./helper";

let mainCircuit: CheckSignature;
before("setup", async () => {
    mainCircuit = await zkit.getCircuit("CheckSignature");
});

it("check a valid ecdsa", async () => {
    const proofStruct = await mainCircuit.generateProof({
        r: encode256(r),
        s: encode256(s),
        pk: [encode256(pk[0]), encode256(pk[1])],
        msgHash: encode256(msgHash),
    });

    expect(proofStruct.publicSignals.out).to.equal(
        "1"
    )
});

it("check an invalid ecdsa", async () => {
    const proofStruct = await mainCircuit.generateProof({
        r: encode256(r + 1n), // invalid r
        s: encode256(s),
        pk: [encode256(pk[0]), encode256(pk[1])],
        msgHash: encode256(msgHash),
    });

    expect(proofStruct.publicSignals.out).to.equal(
        "0"
    )
});
