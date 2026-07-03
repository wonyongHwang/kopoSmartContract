// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    mapping(uint256 => string) private _tokenURIs;

    event NFTMinted(address to, uint256 tokenId, string tokenURI);

    constructor() ERC721("KOPO", "KPO") Ownable(msg.sender) {
        _nextTokenId = 1;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function mintNFT(address to, string memory uri) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId;
        _nextTokenId++;

        _mint(to, tokenId);
        _tokenURIs[tokenId] = uri;

        emit NFTMinted(to, tokenId, uri);

        return tokenId;
    }
}
