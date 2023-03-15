const escrow= artifacts.require("Escrow.sol");

module.exports=function(deployer) {
   const _buyer="0xBC8d0d02314fAb227470ea638fbE2ad39CD45291";
   const _seller="0x061369215f0656899c9fb0d3B5146d8F2d3DFB81";

    deployer.deploy(escrow,_buyer,_seller);

}