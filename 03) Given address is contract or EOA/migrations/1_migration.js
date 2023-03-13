const addresstype=artifacts.require("AddressType.sol");

module.exports=function(deployer) {
    deployer.deploy(addresstype);
};