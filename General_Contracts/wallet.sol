// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet{
    constructor(){
        owner = payable(msg.sender);
    }

    address payable  public owner;

    receive() external payable{}
 
    function withdraw(address _to, uint256 amount) public{
        require(msg.sender == owner, "Not Owner");
        (bool sent, ) = _to.call{value: amount}("");
        require(sent, "Fail to transfer amount");
    }

    function getBalance() public view returns(uint256){
       return address(this).balance;
    }
}