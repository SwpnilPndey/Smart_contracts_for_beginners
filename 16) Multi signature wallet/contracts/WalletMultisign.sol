//SPDX-License-Identifier:GPL-3.0

/* This smart contract is for a simple multi signature wallet. It means 
that the wallet has multiple owners and any transaction from this wallet 
will need approval from majority of owners. The smart contract takes owners' addresses 
and the required no. of approvals at the time of compilation of the contract. 
Any owner can approve or revoke his approval from a transaction. The transaction 
can be executed by any of the owners only when it is approved by the required no. of owners. 

*/

pragma solidity ^0.8.18;

contract WalletMultiSign {
    address[] public owners;
    mapping(address=>bool) public validOwner;
    uint public requiredApprovals;
    
    struct Transaction {
        address to;
        uint sentValue;
        bytes data;
        bool executed;
    }

    Transaction[] public transactions;
    mapping(uint=>mapping(address=>bool)) public approvedTransaction;

    constructor(address[] memory _owners,uint _required) {
        require(_owners.length>0,"Atleast one owner");
        require(_required>0 && _required<=_owners.length,"Invalid required approvals");

        for(uint i=0;i<_owners.length;i++) {
            require(_owners[i]!=address(0),"Invalid address"); 
            require(validOwner[_owners[i]]==false,"Owner is already registered");
            validOwner[_owners[i]]=true;
            owners.push(_owners[i]);
        }   

       requiredApprovals=_required; 

    }

    receive() external payable {

    }

    function submitTx(address _to, uint _sentValue,bytes calldata _data) external {
        require(validOwner[msg.sender]==true,"Not a valid owner");
        transactions.push(Transaction({
            to:_to,
            sentValue:_sentValue,
            data:_data,
            executed:false
        }));
    }

    function approveTx(uint _txID) external {
        require(validOwner[msg.sender]==true,"Not a valid owner");
        require(_txID>=0 && _txID<transactions.length,"Invalid transaction ID");
        require(approvedTransaction[_txID][msg.sender]==false,"Transaction already approved");
        require(transactions[_txID].executed==false,"Transaction already executed");

        approvedTransaction[_txID][msg.sender]=true;

    }

    function approvalCount(uint _txID) private view returns(uint count) {
        for(uint i=0;i<owners.length;i++) {
            if(approvedTransaction[_txID][owners[i]]==true) {
                count++;
            }
        }
    }

    function execute(uint _txID) external {
        require(validOwner[msg.sender]==true,"Not a valid owner");
        require(_txID>=0 && _txID<transactions.length,"Invalid transaction ID");
        require(transactions[_txID].executed==false,"Transaction already executed");
        require(approvalCount(_txID)>=requiredApprovals,"Approvals not sufficient");
        transactions[_txID].executed=true;
        (bool success,) =transactions[_txID].to.call{value:transactions[_txID].sentValue}(transactions[_txID].data);
        require(success==true,"Tx failed");

    }

    function revokeApproval(uint _txID) view external {
        require(validOwner[msg.sender]==true,"Not a valid owner");
        require(_txID>=0 && _txID<transactions.length,"Invalid transaction ID");
        require(transactions[_txID].executed==false,"Transaction already executed");
        require(approvedTransaction[_txID][msg.sender]==true,"Transaction is not approved");
        approvedTransaction[_txID][msg.sender]==false; 
    }


}



