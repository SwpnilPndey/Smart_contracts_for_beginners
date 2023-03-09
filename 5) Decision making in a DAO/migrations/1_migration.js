const dao = artifacts.require("DAO.sol");

module.exports=function(deployer) {
    const _deadline=1680285600;
    const _totalVoters=10;
    deployer.deploy(dao,_deadline,_totalVoters);
}