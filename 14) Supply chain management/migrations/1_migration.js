const supplychain= artifacts.require("SupplyChain.sol");

module.exports=function(deployer) {
    deployer.deploy(supplychain);
}