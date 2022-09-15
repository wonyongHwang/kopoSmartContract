pragma solidity ^0.8.0;
// import "./KIP17.sol";
import "./extensions/KIP17URIStorage.sol";
import "../../../utils/Counters.sol";
contract KOPONFT is KIP17URIStorage {
   
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

   constructor()  KIP17("KOPONFT", "KNFT") {}

    function safeMint(address to, uint256 tokenId) public   {
        _safeMint(to, tokenId, "");
    }

    function mintNFT(string memory tokenURI) public returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);   
        _setTokenURI(newItemId, tokenURI);  
        return newItemId;
    }

    

}
