const bloodbank = artifacts.require("BloodBank.sol");

module.exports = function (deployer) {
  deployer.deploy(bloodbank);
};
