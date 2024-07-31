import { zkit } from "hardhat";
import { verify } from "@zkit"; // typed circuit-object

async function main() {
    const circuit: verify = await zkit.getCircuit("verify");
    const proof = await circuit.generateProof({
        root: "0",

        r: ["0", "0"],
        s: ["0", "0"],
        pk: [["0", "0"], ["0", "0"]],

        proof: ["0", "0", "0", "0"],
        path: ["0", "0", "0", "0"],
    });
    await circuit.verifyProof(proof); // success
}

main()
    .then()
    .catch((e) => console.log(e));
