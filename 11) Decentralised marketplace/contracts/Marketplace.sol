//SPDX-License-Identifier:GPL-3.0

/* This smart contract mimics a simple decentralised marketplace where users can buy and sell products. 
*/
pragma solidity ^0.8.0;

contract Marketplace {
    
    struct Item {
        uint id;
        string name;
        uint price;
        address payable seller;
        address payable buyer;
        bool sold;
    }
    
    mapping(uint => Item) public items;
    uint public itemCount;
    
    event ItemAdded(uint id, string name, uint price, address seller);
    event ItemSold(uint id, address buyer, uint price);
    
    function addItem(string memory _name, uint _price) public {
        itemCount++;
        items[itemCount] = Item(itemCount, _name, _price, payable(msg.sender),payable(0), false);
        emit ItemAdded(itemCount, _name, _price, msg.sender);
    }
    
    function buyItem(uint _id) public payable {
        Item storage item = items[_id];
        
        require(item.id > 0 && item.id <= itemCount, "Item does not exist");
        require(!item.sold, "Item already sold");
        require(msg.value >= item.price, "Not enough Ether provided");
        require(msg.sender != item.seller, "Cannot buy your own item");
        
        item.sold = true;
        item.seller.transfer(msg.value);
        item.buyer=payable(msg.sender);
        
        emit ItemSold(item.id, msg.sender, msg.value);
    }
}
