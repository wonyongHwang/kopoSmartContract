// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyERC1155Token is ERC1155, Ownable {
    using Strings for uint256;

    // 토큰 이름과 심볼
    string public name;
    string public symbol;

    // 각 토큰 ID의 메타데이터 URI를 저장하는 매핑
    mapping(uint256 => string) private _tokenURIs;

    // 토큰 ID 카운터
    uint256 private _currentTokenID = 0;

    // URI를 생성자에서 받아 ERC1155 부모 생성자에 전달, Ownable의 소유자는 msg.sender로 설정
    // initialUri 예시 : "https://game.example/api/item/{id}.json"
    constructor(string memory initialUri) ERC1155(initialUri) Ownable(msg.sender) {
        name = "MyERC1155Token";
        symbol = "MET";
    }

    /**
     * @dev 새로운 토큰을 민트합니다.
     * @param to 토큰을 받을 주소
     * @param amount 토큰의 수량 (대체 가능 토큰의 경우 수량, 대체 불가능 토큰의 경우 1)
     * @param tokenURI 토큰의 메타데이터 URI
     */
    function mint(address to, uint256 amount, string memory tokenURI) public onlyOwner {
        _currentTokenID += 1;
        uint256 newTokenID = _currentTokenID;

        _setTokenURI(newTokenID, tokenURI);

        _mint(to, newTokenID, amount, "");
    }

    /**
     * @dev 다수의 토큰을 한 번에 민트합니다.
     * @param to 토큰을 받을 주소
     * @param ids 토큰 ID 배열
     * @param amounts 각 토큰 ID에 대한 수량 배열
     * @param uris 각 토큰 ID에 대한 메타데이터 URI 배열
     */
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, string[] memory uris) public onlyOwner {
        require(ids.length == uris.length, "IDs and URIs length mismatch");
        for (uint256 i = 0; i < ids.length; i++) {
            _setTokenURI(ids[i], uris[i]);
        }
        _mintBatch(to, ids, amounts, "");
    }

    /**
     * @dev 토큰 URI를 설정합니다.
     * @param tokenId 설정할 토큰 ID
     * @param tokenURI 해당 토큰의 URI
     */
    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal {
        _tokenURIs[tokenId] = tokenURI;
    }

    /**
     * @dev 토큰 URI를 반환합니다.
     * @param tokenId 조회할 토큰 ID
     * @return 해당 토큰의 URI
     */
    function uri(uint256 tokenId) public view virtual override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    // 단일 토큰 전송 함수
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        super.safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev 배치 전송을 오버라이드하여 추가적인 기능을 구현할 수 있습니다.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
        // 추가 로직을 여기에 삽입할 수 있습니다.
    }
}
