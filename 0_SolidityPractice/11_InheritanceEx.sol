// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 첫 번째 부모 컨트랙트
contract A {
    uint public a;

    // A의 생성자
    constructor(uint _a) {
        a = _a;
    }
}

// 두 번째 부모 컨트랙트
contract B {
    uint public b;

    // B의 생성자
    constructor(uint _b) {
        b = _b;
    }
}

// C는 A와 B를 상속받는 컨트랙트
contract C is A, B {
    uint public c;

    // C의 생성자에서 A와 B의 생성자를 명시적으로 호출
    constructor(uint _a, uint _b, uint _c) A(_a) B(_b) {
        c = _c;
        
    }
}

// D는 C를 배포하고 상태 변수를 읽는 함수 포함
contract D {
    C public contractC;

    // C를 배포하는 함수
    function deployC(uint _a, uint _b, uint _c) public {
        // C 컨트랙트를 배포하고 주소를 저장
        contractC = new C(_a, _b, _c);
    }

    // C 컨트랙트의 상태 변수를 읽는 함수
    function getValuesFromC() public view returns (uint, uint, uint) {
        return (contractC.a(), contractC.b(), contractC.c());
    }
}