// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

contract ValueSimple {

    // ===== Value형 예제 =====
    uint public a = 5;
    uint public b;

    function testValue() public {
        b = a;   // 값 복사
        a = 10;  // a를 바꿔도 b는 변하지 않음
        // 결과: a = 10, b = 5
    }

  
}
