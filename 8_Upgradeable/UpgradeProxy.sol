// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    uint public x; // Proxy 컨트랙트에 x 변수 추가
    address public implementation;
    

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function upgrade(address newImplementation) public {
        implementation = newImplementation;
    }

    receive() external payable {  
       
    }

    fallback() external payable {
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }

    function getX() public view returns (uint) {
        return x; // Proxy의 x 값을 직접 반환
    }

}
