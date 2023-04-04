const mktplce = artifacts.require("Marketplace");

module.exports = function (deployer) {
    const feepercent=1;
  deployer.deploy(mktplce,feepercent);
};
