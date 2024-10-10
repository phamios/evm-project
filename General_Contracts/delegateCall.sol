// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

// Her is the storage of DelegateCall contract is used.abi
// TestDelegateCall storage is not affected. 
// And you easily called the testDelegateCall function.

contract TestDelegateCall{
    uint public nums;
    address public sender;
    uint public value;

    function setValue(uint _nums) external payable{
        nums = _nums;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall{
    uint public nums;
    address public sender;
    uint public value;
    bytes public data;

    function callSetValue(address _test, uint _num) external payable{

        // make a delegate call to testDelegateCall contract using abi.encodeWithSelector(bytes4, arg);
        // we can also use abi.encodeWithSelector(bytes4, arg);

        (bool success , bytes memory _data) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setValue.selector, _num)
        );
        require(success, "Failed");
        data = _data;
    }
}