import { ethers } from "hardhat";

async function main() {

const NFTMarket=await ethers.getContractFactory("NFTMarket");
const nftmarket=await NFTMarket.deploy();
await nftmarket.deployed();
console.log("Deployed to : ",nftmarket.address);
}




  
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
