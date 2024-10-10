// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

/* 
In this scenerio we are using contract A and B.
A----->B-----call()------>C
When a account or contract call A.
B makes a call() to account C.

Here C storage varaible gets mutated.
When B----call()---->C
*/

contract TestContract{
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable{
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract NewContract{
    uint public num;
    address public sender;
    uint public value;
    bytes public data;

    function callSetVar(address _test, uint _num) external payable{
        (bool success, bytes memory _data) = _test.call{value: 111}(
            abi.encodeWithSignature("setVars(uint256)", _num));
        require(success, "Failed");
        data = _data;
    }
}

