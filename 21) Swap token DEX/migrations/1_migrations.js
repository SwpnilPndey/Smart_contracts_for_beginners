const swap=artifacts.require("DEX")

module.exports=function(deployer) {
    const tokenAddress="0x64311F21D04534189d60848D8aDfA5Fc07E7B79e";
    const BigNumber = require('bignumber.js');
    const rate = new BigNumber('1000000000000000000');
    deployer.deploy(swap,tokenAddress,rate);
}

