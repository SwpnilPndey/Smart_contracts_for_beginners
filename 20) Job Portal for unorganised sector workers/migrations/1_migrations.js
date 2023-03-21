const jobportal=artifacts.require("MigrantWorkerJobPortal")

module.exports=function(deployer) {
    deployer.deploy(jobportal);
}