import { CheckKeyAndInclusion } from "@/generated-types/zkit";
import { expect } from "chai";
import { zkit } from "hardhat";

describe("Main", () => {
    let mainCircuit: CheckKeyAndInclusion;

    before("setup", async () => {
        mainCircuit = await zkit.getCircuit("CheckKeyAndInclusion");
    });

    it("should simply run", async () => {
        const proofStruct = await mainCircuit.generateProof({
            root: "0",

            r: ["0", "0"],
            s: ["0", "0"],
            pk: [["0", "0"], ["0", "0"]],

            proof: ["0", "0", "0", "0"],
            path: ["0", "0", "0", "0"],
        });

        expect(proofStruct.publicSignals.out).to.equal(
            "1"
        )
    });
});
