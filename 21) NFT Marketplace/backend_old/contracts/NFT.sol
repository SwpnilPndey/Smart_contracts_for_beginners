// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract NFT is ERC721URIStorage {
    uint public tokenCount;

    constructor() ERC721("Tasvica's Art","Art") {}

    function mint(string memory _tokenURI) external returns(uint) {
        tokenCount++;
        _safeMint(msg.sender,tokenCount);
        _setTokenURI(tokenCount, _tokenURI);
        return tokenCount;
    }


}