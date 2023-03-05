const balance = artifacts.require("Balance.sol");

module.exports = function(deployer) {
    deployer.deploy(balance);
};
