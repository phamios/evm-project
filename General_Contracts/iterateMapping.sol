// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mapping{
    mapping (address => uint256) public balance;
    mapping (address => bool) public inserted;
    address[] public arrayKeys;

    function set(address addr, uint256 _value) external {
        balance[addr] = _value;
        if(!inserted[addr]){
            arrayKeys.push(addr);
            inserted[addr] = true;
        }
    }

    function getBalanceLength() external view returns(uint256){
        return arrayKeys.length;
    }

    function getFirstValue() external view returns(uint256){
        return balance[arrayKeys[0]];
    }

    function getLastValue() external view returns(uint256){
        return balance[arrayKeys[arrayKeys.length -1]];
    }

    function getAnyValue(uint _index) external view returns(uint256){
        return balance[arrayKeys[_index]];
    }

}