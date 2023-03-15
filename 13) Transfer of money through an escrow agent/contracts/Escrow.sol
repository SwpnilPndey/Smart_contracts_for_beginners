//SPDX-License-Identifier:GPL-3.0

/* This smart contract implements a trustless escrow system where funds are kept 
with the smart contract until both buyer and seller approve the transfer of amount
to the seller. Then the escrow releases the amount to the seller.

@Devs, kindly change the address of the buyer and seller from the 1_migration.js as 
per your case. These are passed as argument of constructor of the contract.

*/

pragma solidity ^0.8.0;

contract Escrow {
    address payable public buyer;
    address payable public seller;
    address payable public escrowAgent;
    uint public contractBalance;
    int public buyerBalance;
    uint public sellerBalance;
    uint public amount;
    bool public sellerApproved;
    bool public buyerApproved;

    constructor(address payable _buyer, address payable _seller) payable {
        buyer = _buyer;
        seller = _seller;
        escrowAgent = payable(msg.sender);
        sellerApproved = false;
        buyerApproved = false;
    }

    function receiveFromBuyer() public payable {
        require(msg.sender==buyer,"Amount can only be transferred by buyer");
        amount=msg.value;
        contractBalance+=amount;
        buyerBalance-=int(amount);

    }

    function approveBySeller() public {
        require(msg.sender == seller,"You are not the seller");
        sellerApproved = true;
    }

    function approveByBuyer() public {
        require(msg.sender == buyer,"You are not the buyer");
        buyerApproved = true;
    }

    function release() public {
        require(sellerApproved == true && buyerApproved == true,"Amount cant be released without concurrence of both buyer and seller");
        require(msg.sender == escrowAgent,"You are not the escrow agent");
        payable(seller).transfer(amount);
        contractBalance-=amount;
        sellerBalance+=amount;
    }

    function refund() public {
        require(sellerApproved == false || buyerApproved == false,"Both seller and buyer have approved the transfer, so refund not possible");
        require(msg.sender == escrowAgent,"You are not the escrow agent");
        payable(buyer).transfer(amount);
        contractBalance-=amount;
        buyerBalance+=int(amount);
    }
}
