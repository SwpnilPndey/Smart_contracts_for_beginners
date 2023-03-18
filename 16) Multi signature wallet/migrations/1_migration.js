const multisig=artifacts.require("WalletMultiSign");

module.exports=function(deployer) {
    const _owners=["0x8F14141d47c56A2d0114D40490b2c64Fc6728a20","0x4BFeFbb3F0B373E727c37196D9fb54fDAb4b17dc","0xAAEfA47910B8763c3dEF369f31fae96B610055ae"];
    const _required=2;
    deployer.deploy(multisig,_owners,_required);
}