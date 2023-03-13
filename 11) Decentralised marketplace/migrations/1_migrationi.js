const marketplace= artifacts.require("Marketplace.sol");

module.exports=function(deployer) {
    deployer.deploy(marketplace);
}