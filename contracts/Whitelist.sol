//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WhitelistContract is ERC721URIStorage {
    using Counters for Counters.Counter;

    address public owner;
    address public contractAddress;
    Counters.Counter private _tokenIds;

    mapping(address => bool) private isOwner;
    mapping(address => bool) private whitelistAddrs;

    constructor(address marketplaceAddr) ERC721("Midnight Token", "MNT") {
        owner = marketplaceAddr;
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

    // modifier whitelisted - checks to see if the msg.sender is whitelisted to interact with the contract.
    modifier whitelisted(address _addr) {
        require(whitelistAddrs[_addr], "you need to be whitelisted");
        _;
    }

    // NFT Functions
    /// @dev   - list of contract functions avaibale.
    /// @return Documents the return variables of a contract’s function state variable
    function createNewNFT() public view whitelisted(msg.sender) returns (bool) {
        return (true);
    }

    // createToken - creates a token on the marketplace if the address is whitelisted.
    function createToken(string memory _tokenURI)
        public
        whitelisted(msg.sender)
        returns (uint256)
    {
        // require the msg.sender to be whilelisted, just in case.
        require(whitelistAddrs[msg.sender] == true, "need to be whitelisted");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }
}
