const withdrawfunds =  artifacts.require("WithdrawFunds.sol");

module.exports =function(deployer) {
    deployer.deploy(withdrawfunds);
}