//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

contract WhitelistContract is ERC721URIStorageUpgradeable {
    address public owner;
    mapping(address => bool) private isOwner;
    mapping(address => bool) private whitelistAddrs;
    mapping(address => uint256) public owned;

    constructor() {
        owner = msg.sender;
    }

    // modifier allows ups to restrict ONLY to the creator.

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    /// @notice -  adding a user can only be done by the owner.
    /// @dev    -  refer to the onlyOwner() modifier.
    ///            true -> whitelisted.
    ///            false -> not listed.
    function addUser(address _whitelistAddr) public onlyOwner {
        whitelistAddrs[_whitelistAddr] = true;
    }

    modifier whitelisted(address _addr) {
        require(whitelistAddrs[_addr], "you need to be whitelisted");
        _;
    }

    // NFT Functions
    /// @notice Explain to an end user what this does
    /// @dev Explain to a developer any extra details
    /// @return Documents the return variables of a contract’s function state variable
    function mintNFT() public view whitelisted(msg.sender) returns (bool) {
        return (true);
    }

    function checkNFTs(address _addr) public view returns (uint256) {
        return 0;
    }
}
