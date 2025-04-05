// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FixedArrayExam {
    uint[5] private fArray = [uint(10), 20, 30, 40, 50];

    function pushItem(uint _idx, uint _value) public {
        fArray[_idx] = _value;
    }

    function getItem(uint _idx) public view returns (uint) {
        return fArray[_idx];
    }

    function getLength() public view returns (uint) {
        return fArray.length;
    }

    function clearArray() public returns (uint) {
        delete fArray;
        return fArray.length;
    }

    function getArray() public pure returns (uint[3] memory year) {
        year = [uint(1994), 1997, 1009];
        return year;
    }
}
