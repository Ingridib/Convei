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
