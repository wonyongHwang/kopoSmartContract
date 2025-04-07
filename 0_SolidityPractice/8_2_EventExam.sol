// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventExam {
    uint public value = 10;

    event Log(uint oldValue, uint newValue);

    function setValue(uint newValue) public {
        emit Log(value, newValue);
        value = newValue;
    }
}
