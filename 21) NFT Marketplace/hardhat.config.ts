import { HardhatUserConfig } from "hardhat/config";
import "dotenv/config";
import "@nomicfoundation/hardhat-toolbox";
const PRIVATE_KEY = process.env.PRIVATE_KEY as string;
const PROJECT_URL = process.env.PROJECT_URL as string;

const config: HardhatUserConfig = {
  solidity: "0.8.18",

  networks: {
    sepolia: {
      url: PROJECT_URL,
      accounts: [PRIVATE_KEY],
    },
  },

};

export default config;
