const nft =  artifacts.require("MyNFT.sol");

module.exports=function(deployer) {
    deployer.deploy(nft);
}