// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract UpgradableContract is 
                            UUPSUpgradeable,
                            OwnableUpgradeable 
                            {

    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private changeId;
    uint public number;

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}


    // The initialize function will be used to set up the initial state of the contract.
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        number = 10;
    }


     function updateNumber(uint _number) public returns (uint, uint) {
        number = _number;
        changeId.increment();
        uint id = changeId.current();
        return (number, id);
    }
    
}
      