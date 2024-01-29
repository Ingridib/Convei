// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title UniqueIdToken
 * @author Ingrid Backa
 * @copyright Copyright (c) 2022, Ingrid Backa Convei
 * @license GNU General Public License v3.0
 */

contract UniqueIdToken {
    struct Token {
        address owner;
        uint uniqueId;
        bool transferable;
    }

    mapping (uint => Token) public tokenById;
    mapping (address => uint) public tokensByOwner;
    uint private _tokenIdCounter;

    constructor() {
        _tokenIdCounter = 1;
    }

    function generateToken() public returns (uint) {
        require(_tokenIdCounter <= type(uint).max, "Maximum number of tokens reached.");
        Token memory newToken;
        newToken.owner = msg.sender;
        newToken.uniqueId = _tokenIdCounter;
        newToken.transferable = true;
        tokenById[_tokenIdCounter] = newToken;
        tokensByOwner[msg.sender] += 1;
        return _tokenIdCounter++;
    }

    function getTokenById(uint tokenId) public view returns (address owner, uint uniqueId, bool transferable) {
        Token memory token = tokenById[tokenId];
        owner = token.owner;
        uniqueId = token.uniqueId;
        transferable = token.transferable;
    }

    function getTokensByOwner(address owner) public view returns (uint) {
        return tokensByOwner[owner];
    }

    function transferToken(uint tokenId, address newOwner) public {
        Token memory token = tokenById[tokenId];
        require(token.owner == msg.sender, "Token is not owned by the sender.");
        require(token.transferable, "Token is not transferable.");
        token.owner = newOwner;
        tokensByOwner[newOwner] += 1;
        tokensByOwner[msg.sender] -= 1;
    }

    function setTransferable(uint tokenId, bool newTransferable) public {
        Token memory token = tokenById[tokenId];
        require(token.owner == msg.sender, "Token is not owned by the sender.");
        token.transferable = newTransferable;
    }

    function generateLabel(uint tokenId) public view returns (string memory) {
        Token memory token = tokenById[tokenId];
        require(token.owner == msg.sender, "Token is not owned by the sender.");
        return string(abi.encodePacked("This data is labeled with unique ID: ", token.uniqueId.toString(), " and is released under the GNU General Public License v3.0 (GPLv3)"));
    }
}
