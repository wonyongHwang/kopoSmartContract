// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract MyERC1155Receiver is IERC1155Receiver {
    // 수신자가 ERC-1155 토큰을 받을 수 있는지를 검증하는 로직
    mapping(uint256 => bool) public acceptedTokens;
    mapping(uint256 => uint256) public tokenBalances;

    // 이벤트 선언: 전송된 토큰 정보를 기록
    event TokenReceived(address operator, address from, uint256 id, uint256 value, bytes data);
    event BatchTokenReceived(address operator, address from, uint256[] ids, uint256[] values, bytes data);

    constructor() {
        // 예시로 토큰 ID 1만 허용
        acceptedTokens[1] = true;
    }

    // ERC1155Receiver 인터페이스 구현
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override returns (bytes4) {
        // 수락 가능한 토큰 ID만 허용
        require(acceptedTokens[id], "Token ID not accepted");

        // 받은 토큰의 수량 기록
        tokenBalances[id] += value;

        // 이벤트 발생
        emit TokenReceived(operator, from, id, value, data);

        // 검증 후, onERC1155Received selector 반환
        return this.onERC1155Received.selector;
    }

    // 배치 전송에 대한 수락 로직
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override returns (bytes4) {
        for (uint256 i = 0; i < ids.length; i++) {
            require(acceptedTokens[ids[i]], "Token ID not accepted");
            tokenBalances[ids[i]] += values[i];
        }

        // 배치 이벤트 발생
        emit BatchTokenReceived(operator, from, ids, values, data);

        return this.onERC1155BatchReceived.selector;
    }

   // ERC165 인터페이스 지원
   // IERC1155Receiver의 interfaceId는 ERC-165 표준에 따라 두 개의 함수 시그니처에 대한 해시 값을 XOR 연산을 통해 계산됨
   // IERC1155Receiver의 interfaceId는 0x4e2312e0
    function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }
}
