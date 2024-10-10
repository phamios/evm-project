// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Modifier{
    uint256 public count;

    modifier sandwich(){
        count += 1;
        _;
        count *= 2;
    }

    function foo() public sandwich() returns(uint256){
        return count += 1;
    }
}