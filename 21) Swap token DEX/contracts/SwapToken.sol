// SPDX-License-Identifier: MIT

/* This smart contract swaps 1 BEP20 token for 1 USDT token. We must remember that 1 USDT token = 1e18 wei. 
For the sake of the project token address has been taken as : 0x64311F21D04534189d60848D8aDfA5Fc07E7B79e", however, in real 
scenario, it will be different. 
*/

pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}




contract DEX {

    using SafeMath for uint;

    event Bought(uint amount);
    //event Sold(uint amount);

    uint public Rate=1e18;


    address public  ContractOwner;
    IERC20 public token;

    constructor(address TokenAddress,uint _rate) { 
           token = IERC20(TokenAddress);
           ContractOwner=msg.sender;
           Rate=_rate;
    }


     modifier onlyOwner() {
        require(msg.sender == ContractOwner, "sender is not the owner");
        _;
    }


    function EtherToToken() payable public {
        uint UserSendEther = msg.value;
        uint UserGetToken=UserSendEther * Rate/1e18;
        uint dexBalance = token.balanceOf(address(this));
        require(UserSendEther > 0, "You need to send some ether");
        require(UserGetToken <= dexBalance, "Not enough tokens in the reserve");
        token.transfer(msg.sender, UserGetToken);
        emit Bought(UserGetToken);
    }


        function GetAmountsOut(uint UserSendEther)  view public returns (uint){
            return  UserSendEther * Rate/1e18;
        }

        function SetRate(uint NewRate)    public onlyOwner {
             Rate= NewRate;
        }

       function TransferToken(address ToAddress,uint Amount)    public onlyOwner {
              token.transfer(ToAddress, Amount);
        }


       function TransferETH( address payable _receiver,uint256 _Amount) public onlyOwner  {
        (_receiver).transfer(_Amount);
       }


/*
    function sell(uint256 amount) public {
        require(amount > 0, "You need to sell at least some tokens");
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        token.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);
        emit Sold(amount);
    }
*/
}