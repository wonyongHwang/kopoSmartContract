// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyFirstContract{
    function sayHello() public pure returns (string memory){
        return 'Hello World';
    }

    function sayHello2(string memory name) public pure returns (string memory) {
        // 받은 파라미터 name과 'Hello World'를 연결합니다.
        string memory greeting = string(abi.encodePacked('Hello World ', name));
        return greeting;
    }
}
