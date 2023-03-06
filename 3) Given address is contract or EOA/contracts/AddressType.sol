//SPDX-License-Identifier:GPL-3.0

pragma solidity ^0.8.18;

contract AddressType {
       
    function addressType(address addr) public view returns(string memory) {
        uint size;
        assembly {size:=extcodesize(addr)}
        if(size>0)
        return "It is a contract address";
        else
        return "It is an Externally owned account adress";
    }
}