const crowdfunding= artifacts.require("Crowdfunding.sol");

module.exports=function(deployer) {
    const fundinglimit=5000;
    deployer.deploy(crowdfunding,fundinglimit);
}