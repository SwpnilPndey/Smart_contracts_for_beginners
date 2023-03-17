const reputation=artifacts.require("ReputationSystem");

module.exports=function(deployer) {
    deployer.deploy(reputation);
}