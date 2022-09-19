// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MemorizeThisDay.sol";

contract MemorizeThisDayOnBNB is MemorizeThisDay {
    constructor(
        address vrfCoordinator,
        address linkToken,
        uint256 chainlinkFee,
        bytes32 keyHash,
        address priceFeedAddress,
        address developersAddress,
        address founderAddress
    )
        public
        MemorizeThisDay(
            "Binance",
            "https://memorizethisday.github.io/BNB/{id}.json",
            70,
            vrfCoordinator,
            linkToken,
            chainlinkFee,
            keyHash,
            priceFeedAddress,
            2017,
            11,
            13
        )
    {
        SetAddress(founderAddress, 0);
        SetAddress(developersAddress, 1);
        _airdrop[founderAddress] = 15;
    }
}
