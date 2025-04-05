pragma solidity ^0.8.0;

contract ArrayExam2 {
    uint[] number;
    uint[] year = [uint(1992), 1994, 1997];
    uint[] age = new uint[](5);

    function pushItem(uint _item) public returns (uint) {
        year.push(_item);
        return year.length - 1;
    }

    function getItem(uint _idx) public view returns (uint) {
        return year[_idx];
    }

    function testArray(uint _len) public pure returns (uint[] memory) {
        uint[] memory array = new uint[](_len);

        for (uint i = 0; i < _len; i++) {
            array[i] = i;
        }

        return array;
    }
}
