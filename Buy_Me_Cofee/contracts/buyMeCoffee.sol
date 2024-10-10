// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
// import "hardhat/console.sol";

contract BuyMeCoffee {

    constructor(){
        owner = payable(msg.sender);
    }

    address payable owner;
    uint public coffeePrice = 5 ether;

    event NewMemo(address indexed from, string name, string message);

    struct Memo{
        address from;
        string name;
        string message;
        uint256 timestamp;
    }

    // Memo[] allMemos;
    mapping (address => Memo[]) memos;

    receive() external payable{}

    function contactBalance() public view returns(uint){
        return address(this).balance;
    }

    function buy(string calldata _name, string calldata _message, uint _quantity) public payable{
        uint totalValue = coffeePrice * _quantity;
        require(msg.value > totalValue, "Your balance is low!!");
        memos[msg.sender].push(Memo(msg.sender, _name, _message, block.timestamp));
        emit NewMemo(msg.sender, _name, _message);
    }

    function getMemo() public view returns(Memo[] memory){
        return memos[msg.sender];
    }

    function transferFund() public{
        uint balance = address(this).balance;
        (bool sent, ) = owner.call{value:balance}("");
        require(sent, "Fail to transafer amount");
    }
}