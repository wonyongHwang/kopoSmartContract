// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract structure {

    struct Person {
        string name;
        int age;
    }

    Person customer;

    constructor() payable {
        customer = Person({name : 'hong', age: 1});
    }
    // 이더를 받을 수 있는 receive 함수
    receive() external payable {}
    
    // customer의 상태값을 조회하는 함수
    function getPerson() public view returns (string memory, int) {
        return (customer.name, customer.age);
    }

    // customer의 상태값을 변경하는 함수
    function setPerson(string memory _name, int _age) public {
        customer.name = _name;
        customer.age = _age;
    }
}

