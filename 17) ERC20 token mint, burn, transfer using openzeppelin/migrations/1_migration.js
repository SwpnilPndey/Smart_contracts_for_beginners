const erc20_openzep = artifacts.require("MyToken");

module.exports=function(deployer) {
    const initSup=50000;    
    deployer.deploy(erc20_openzep,initSup);

}