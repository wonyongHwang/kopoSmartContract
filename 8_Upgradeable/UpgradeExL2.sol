// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicV2 {
    uint public x;

    function increment() public {
        x += 1;
    }

    function incrementBy(uint _value) public {
        x += _value;
    }
}
