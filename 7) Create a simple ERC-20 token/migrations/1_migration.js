const erc20 = artifacts.require("CreateERC20.sol");

module.exports = function(deployer) {
    deployer.deploy(erc20);
}