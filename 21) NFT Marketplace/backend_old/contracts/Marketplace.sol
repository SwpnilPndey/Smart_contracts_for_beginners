// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is ReentrancyGuard {
    address payable public immutable feeAccount; //immutable means value can't change
    uint public immutable feePercent;
    uint public itemCount;

    constructor(uint _feePercent) {
        feeAccount=payable(msg.sender);
        feePercent=_feePercent;
    }

    struct Item {
        uint itemID;
        IERC721 nft;
        uint tokenID;
        uint price;
        address payable seller;
        bool sold;
    }

    event Offered(uint itemID, address indexed nft, uint tokenID, uint price, address indexed seller);
    event Bought(uint itemID, address indexed nft, uint tokenID, uint price, address indexed seller,address indexed buyer);

    mapping(uint=>Item) public items;

    function makeItem(IERC721 _nft, uint _tokenID, uint _price) external nonReentrant {
        require(_price>=0,"Price cannot be zero");
        itemCount++;
        _nft.transferFrom(msg.sender, address(this), _tokenID);
        items[itemCount]=Item(itemCount,_nft,_tokenID,_price,payable(msg.sender),false);

        emit Offered(itemCount,address(_nft),_tokenID,_price,msg.sender);
    }

    function purchaseItem(uint _itemID) external payable nonReentrant {
        uint _totalPrice=getTotalPrice(_itemID);
        Item storage item=items[_itemID];
        require(_itemID>0 && _itemID<itemCount,"Invalid Item ID");
        require(msg.value>=_totalPrice,"Not enough ether sent");
        require(item.sold==false,"Item already sold");
        item.seller.transfer(_totalPrice);
        feeAccount.transfer(_totalPrice-item.price);

        item.sold=true;
        item.nft.transferFrom(address(this), msg.sender,item.tokenID);

        emit Bought(_itemID,address(item.nft),item.tokenID,item.price,item.seller,msg.sender);
    } 

    function getTotalPrice(uint _itemID) public view returns(uint) {
        return(items[_itemID].price*(100*feePercent)/100);
    }

}