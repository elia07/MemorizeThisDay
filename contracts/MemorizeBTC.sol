// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MemorizeThisDay.sol";

contract MemorizeThisDayOnBTC is MemorizeThisDay {
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
            "Bitcoin",
            "https://memorizethisday.github.io/BTC/{id}.json",
            50,
            vrfCoordinator,
            linkToken,
            chainlinkFee,
            keyHash,
            priceFeedAddress,
            2009,
            1,
            3
        )
    {
        SetAddress(founderAddress, 0);
        SetAddress(developersAddress, 1);
        _airdrop[founderAddress] = 20;
        _airdrop[developersAddress] = 20;
        Memorize(2016, 7, 9, founderAddress);
        Memorize(2013, 1, 1, founderAddress);
        Memorize(2009, 1, 3, founderAddress);
        Memorize(2021, 10, 20, founderAddress);
        Memorize(2015, 1, 15, founderAddress);
    }
}
