// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract GameItems is ERC1155, Ownable {

    string private baseURI;

    // 대체 가능한 토큰 (FT)
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;

    // 대체 불가능한 토큰 (NFT)
    uint256 public constant THORS_HAMMER = 2;
    uint256 public constant EXCALIBUR = 3;  // 또 다른 NFT 예시

    // 각 토큰에 대응하는 메타데이터 URI를 설정하기 위한 기본 URI 템플릿 (https://game.example/api/item/{id}.json)
    constructor(string memory initialUri) ERC1155(initialUri) Ownable(msg.sender) {
        baseURI = initialUri;

        // 대체 가능한 토큰 (FT)
        _mint(msg.sender, GOLD, 10**18, "");  // 1,000,000,000,000,000,000 GOLD
        _mint(msg.sender, SILVER, 10**27, ""); // 1,000,000,000,000,000,000,000,000,000 SILVER

        // 대체 불가능한 토큰 (NFT)
        _mint(msg.sender, THORS_HAMMER, 1, ""); // 유일한 토큰 1개
        _mint(msg.sender, EXCALIBUR, 1, "");    // 또 다른 유일한 토큰 1개
    }

    // 특정 토큰 ID에 해당하는 URI를 반환 (기본 템플릿에서 {id}를 토큰 ID로 대체)
    function uri(uint256 tokenId) public pure override returns (string memory) {
        return string(abi.encodePacked(
            "https://game.example/api/item/", 
            Strings.toString(tokenId), 
            ".json"
        ));
    }
     // 기본 URI 조회 함수
    function getBaseURI() public view returns (string memory) {
        return baseURI;
    }

    // FT와 NFT를 전송하는 메커니즘은 ERC1155 표준에서 제공되며 안전한 전송을 보장
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        super.safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }
}
