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
    }

    mapping (uint => Token) public tokenById;
    uint private _tokenIdCounter;

    function generateToken() public returns (uint) {
        require(_tokenIdCounter < type(uint).max, "Maximum number of tokens reached.");
        Token memory newToken;
        newToken.owner = msg.sender;
        newToken.uniqueId = _tokenIdCounter;
        tokenById[_tokenIdCounter] = newToken;
        return _tokenIdCounter++;
    }

    function getTokenById(uint tokenId) public view returns (address owner, uint uniqueId) {
        Token memory token = tokenById[tokenId];
        owner = token.owner;
        uniqueId = token.uniqueId;
    }
}

 function getTokensByOwner(address owner) public view returns (uint) {
        return tokensByOwner[owner];
    }

    function transferToken(uint tokenId, address newOwner) public {
        require(tokenById[tokenId].owner == msg.sender, "Token is not owned by the sender.");
        tokenById[tokenId].owner = newOwner;
        tokensByOwner[newOwner] += 1;
        tokensByOwner[msg.sender] -= 1;
    }

    function generateLabel(uint tokenId) public view returns (string memory) {
        Token memory token = tokenById[tokenId];
        require(token.owner == msg.sender, "Token is not owned by the sender.");
        return string(abi.encodePacked("This data is labeled with unique ID: ", token.uniqueId.toString(), " and is released under the GNU General Public License v3.0 (GPLv3)"));
    }
}
