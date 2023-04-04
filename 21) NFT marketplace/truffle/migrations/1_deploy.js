const nft = artifacts.require("NFT");

module.exports = function (deployer) {
  deployer.deploy(nft);
};
