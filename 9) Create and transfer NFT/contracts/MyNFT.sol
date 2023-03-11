//SPDX-License-Identifier:GPL-3.0

pragma solidity ^0.8.0;

/* This smart contract creates ERC-721 complied NFT. 

ERC 721 standard : 

The ERC721 standard is a set of rules or guidelines that define a common interface for 
non-fungible tokens (NFTs) on the Ethereum blockchain.

There are a total of 13 functions and 2 events that are considered mandatory in the ERC721 standard. These functions and events are:

- balanceOf: Returns the number of tokens owned by a specific address.
- ownerOf: Returns the address of the owner of a specific token.
- safeTransferFrom: Transfers ownership of a token from one address to another address. This function should revert if the transfer fails.
- safeTransferFrom: Transfers ownership of a token from one address to another address. This function should return a boolean indicating whether the transfer succeeded.
- transferFrom: Transfers ownership of a token from one address to another address.
- approve: Approves another address to transfer the given token ID.
- setApprovalForAll: Enables or disables approval for a third party ("operator") to manage all of the caller's tokens.
- getApproved: Returns the address currently approved for the given token ID.
- isApprovedForAll: Returns true if the given operator is approved to manage all of the tokens of the given owner.
- name: Returns the name of the token.
- symbol: Returns the symbol of the token.
- totalSupply: Returns the total number of tokens in existence.
- tokenOfOwnerByIndex: Returns the token ID of the nth token owned by a specific address.

The two events that are mandatory are:

- Transfer: Emits when ownership of a token changes.
- Approval: Emits when the approval of a token is transferred or set.


For the sake of the project here, the isApprovedForAll() function is used as a stub function and 
always a returns a false boolean.


*/

pragma solidity ^0.8.0;

contract MyNFT {
    
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    
    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownershipTokenCount;
    mapping(uint256 => address) private _tokenApprovals;

    uint256 private _totalSupply = 0;

    
    function balanceOf(address _owner) public view returns (uint256) {
        return _ownershipTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        return _tokenOwner[_tokenId];
    }

    function approve(address _approved, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_approved != owner);
        require(msg.sender == owner || isApprovedForAll());
        _tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public {
        require(_to != address(0));
        require(_to != address(this));
        require(msg.sender == ownerOf(_tokenId) || msg.sender == getApproved(_tokenId) || isApprovedForAll());
        _transfer(msg.sender, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(_to != address(0));
        require(_to != address(this));
        require(msg.sender == getApproved(_tokenId) || msg.sender == ownerOf(_tokenId));
        require(msg.sender == ownerOf(_tokenId) || isApprovedForAll());
        require(ownerOf(_tokenId) == _from);
        _transfer(_from, _to, _tokenId);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function mint(address _to, uint256 _tokenId) public {
        require(_to != address(0));
        require(_to != address(this));
        require(_tokenOwner[_tokenId] == address(0));
        _tokenOwner[_tokenId] = _to;
        _ownershipTokenCount[_to]++;
        _totalSupply++;
        emit Transfer(address(0), _to, _tokenId);
    }

    
    function _transfer(address _from, address _to, uint256 _tokenId) private {
        _tokenOwner[_tokenId] = _to;
        _ownershipTokenCount[_from]--;
        _ownershipTokenCount[_to]++;
        _tokenApprovals[_tokenId] = address(0);
        emit Transfer(_from, _to, _tokenId);
    }

    function isApprovedForAll() public pure returns (bool) {
        return false;
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        return _tokenApprovals[_tokenId];
    }
}

