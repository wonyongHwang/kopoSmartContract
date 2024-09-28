// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ModifierExam{

    int public  cnt = 0;

    modifier check(){
        cnt++;
        _;
    }

    function getCount() public check returns (int) {
        return cnt;
    }
}