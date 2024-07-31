import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@solarity/hardhat-zkit";

const config: HardhatUserConfig = {
    zkit: {
        circuitsDir: "circuits",
        compilationSettings: {
            artifactsDir: "zkit/artifacts",
            onlyFiles: [],
            skipFiles: [],
            c: false,
            json: false,
            sym: false,
        },
        setupSettings: {
            contributionSettings: {
                contributionTemplate: "groth16",
                contributions: 1,
            },
            onlyFiles: [],
            skipFiles: [],
            ptauDir: undefined,
            ptauDownload: true,
        },
        typesSettings: {
            typesArtifactsDir: "zkit/abi",
            typesDir: "generated-types/zkit",
        },
        verifiersDir: "contracts/verifiers",
        nativeCompiler: true,
        quiet: false,
    },
};

export default config;
