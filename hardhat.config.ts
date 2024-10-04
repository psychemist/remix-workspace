import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const { vars } = require("hardhat/config");
const ALCHEMY_API_KEY = vars.get("ALCHEMY_API_KEY");
const ETHERSCAN_API_KEY = vars.get("ETHERSCAN_API_KEY");
const BASE_BLOCKSCOUT_API_KEY = vars.get("BASE_BLOCKSCOUT_API_KEY");
const BASE_RPC_URL = vars.get("BASE_RPC_URL");
const LISK_RPC_URL = vars.get("LISK_RPC_URL");
const SEPOLIA_RPC_URL = vars.get("SEPOLIA_RPC_URL");
const ACCOUNT_PRIVATE_KEY = vars.get("ACCOUNT_PRIVATE_KEY");

const config: HardhatUserConfig = {
    solidity: "0.8.24",
    networks: {
        "sepolia": {
            url: `${SEPOLIA_RPC_URL}/${ALCHEMY_API_KEY}`,
            accounts: [ACCOUNT_PRIVATE_KEY],
        },
        "base-sepolia": {
            url: BASE_RPC_URL!,
            accounts: [ACCOUNT_PRIVATE_KEY],
            gasPrice: 1000000000,
        },
        "lisk-sepolia": {
            url: LISK_RPC_URL!,
            accounts: [ACCOUNT_PRIVATE_KEY],
            gasPrice: 1000000000,
        },
    },
    etherscan: {
        apiKey: {
            "sepolia": ETHERSCAN_API_KEY,
            // "base-sepolia": "PLACEHOLDER_STRING",
            "base-sepolia": BASE_BLOCKSCOUT_API_KEY,
            "lisk-sepolia": "123",
        },
        customChains: [
            {
                network: "base-sepolia",
                chainId: 84532,
                // urls: {
                //     apiURL: "https://api-sepolia.basescan.org/api",
                //     browserURL: "https://sepolia.basescan.org"
                // },
                urls: {
                    apiURL: "https://base-sepolia.blockscout.com/api",
                    browserURL: "https://base-sepolia.blockscout.com"
                }
            },
            {
                network: "lisk-sepolia",
                chainId: 4202,
                urls: {
                    apiURL: "https://sepolia-blockscout.lisk.com/api",
                    browserURL: "https://sepolia-blockscout.lisk.com/",
                },
            },
        ],
    },
    defaultNetwork: "hardhat",
    sourcify: {
        enabled: false,
    },
};

export default config;
