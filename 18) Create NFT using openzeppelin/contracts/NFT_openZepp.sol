//SPDX-License-Identifier:GPL-3.0

/* This smart contract can be used to mint NFTs using the OpenZeppelin library. 
Each new NFT is assigned a token ID (starting from zero). 

mintNFT function mints a NFT and sends it to the desired address along with the URI of the 
deployed token. 

For the purpose of this contract, the metadata has been stored in Pinata IPFS which can be 
caled during function call. 

This contract is deployed on goerli testnet. 
*/



pragma solidity ^0.8.18;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract NewNFT is ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIDs;

    constructor() ERC721("Royal Enfield","ENFLD") {}
    
    // This constructor only gives branding to the NFT and doesnot create a NFT. 
    // For creating a NFT, minting function has to be used with a _to address and a tokenURI
    
    function mintNFT(address _to, string memory _tokenURI) public onlyOwner returns(uint256) {
        _tokenIDs.increment();
        uint256 newTokenID = _tokenIDs.current();
        _mint(_to,newTokenID);
        _setTokenURI(newTokenID, _tokenURI);
        return newTokenID;
    }




}