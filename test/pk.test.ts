import { IsPKValid } from "@/generated-types/zkit";
import { expect } from "chai";
import { zkit } from "hardhat";
import { encode256, pk } from "./helper";

let mainCircuit: IsPKValid;
before("setup", async () => {
    mainCircuit = await zkit.getCircuit("IsPKValid");
});

it("check a valid pk", async () => {
    const proofStruct = await mainCircuit.generateProof({
        pk: [encode256(pk[0]), encode256(pk[1])],
    });

    expect(proofStruct.publicSignals.out).to.equal(
        "1"
    )
});

it("check the twin pk", async () => {
    const p = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2Fn;
    const proofStruct = await mainCircuit.generateProof({
        pk: [encode256(pk[0]), encode256(p - pk[1])],
    });

    expect(proofStruct.publicSignals.out).to.equal(
        "1"
    )
});

it("check an invalid pk", async () => {
    const proofStruct = await mainCircuit.generateProof({
        pk: [encode256(pk[0]), encode256(pk[1] + 1n)],
    });

    expect(proofStruct.publicSignals.out).to.equal(
        "0"
    )
});
