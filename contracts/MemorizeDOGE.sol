// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MemorizeThisDay.sol";

contract MemorizeThisDayOnDOGE is MemorizeThisDay {
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
            "Doge",
            "https://memorizethisday.github.io/DOGE/{id}.json",
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
        _airdrop[founderAddress] = 45;
        Memorize(2017, 11, 13, developersAddress);
        Memorize(2017, 11, 14, developersAddress);
        Memorize(2017, 11, 15, developersAddress);
        Memorize(2017, 11, 16, developersAddress);
        Memorize(2017, 11, 17, developersAddress);
        Memorize(2017, 11, 18, developersAddress);
        Memorize(2017, 11, 19, developersAddress);
        Memorize(2017, 11, 20, developersAddress);
        Memorize(2017, 11, 21, developersAddress);
        Memorize(2017, 11, 22, developersAddress);

        Memorize(2017, 11, 23, founderAddress);
        Memorize(2017, 11, 24, founderAddress);
        Memorize(2017, 11, 25, founderAddress);
        Memorize(2017, 11, 26, founderAddress);
        Memorize(2017, 11, 27, founderAddress);

        //Initial invites to our community
        Memorize(
            2017,
            12,
            1,
            address(0x51EAC3dAA1C34F5c2874Aa62097ac9965A180B6D)
        );
        Memorize(
            2017,
            12,
            2,
            address(0x8836C14Dc2b96123F132CB419B212C46247DDE41)
        );
        Memorize(
            2017,
            12,
            3,
            address(0x13DDf16f41f9A634EACa69bE176773FE5C629c1E)
        );
        Memorize(
            2017,
            12,
            4,
            address(0x00E7B17287365F3Bc59085ff5F3F56eaf1225A0D)
        );
        Memorize(
            2017,
            12,
            5,
            address(0x71B9DF21780CceC1BC19A4c50564F6741F692cdc)
        );
        Memorize(
            2017,
            12,
            6,
            address(0x6CcD607e6E2cc97574Acd5ab0f2b4D24C7F2A061)
        );
        Memorize(
            2017,
            12,
            7,
            address(0x51EAC3dAA1C34F5c2874Aa62097ac9965A180B6D)
        );
        Memorize(
            2017,
            12,
            8,
            address(0xb907e8D3F9AB2A94D476421FB2E6a68Fd516A90c)
        );
        Memorize(
            2017,
            12,
            9,
            address(0x67954aC510255B6B3724073022196b67bdF260B6)
        );
        Memorize(
            2017,
            12,
            10,
            address(0x67954aC510255B6B3724073022196b67bdF260B6)
        );
        Memorize(
            2017,
            12,
            11,
            address(0xb7F7F6C52F2e2fdb1963Eab30438024864c313F6)
        );
        Memorize(
            2017,
            12,
            12,
            address(0x6CcD607e6E2cc97574Acd5ab0f2b4D24C7F2A061)
        );
        Memorize(
            2017,
            12,
            13,
            address(0x6CcD607e6E2cc97574Acd5ab0f2b4D24C7F2A061)
        );
        Memorize(
            2017,
            12,
            14,
            address(0x484c6DcD50978B9D525cC20a02d5801F492931F8)
        );
        Memorize(
            2017,
            12,
            15,
            address(0x027750420d3F4DD56F558871792b1632A21c6205)
        );
        Memorize(
            2017,
            12,
            16,
            address(0xe6dDCC4BFc2876CC71912A0dd04b4318A2F1017D)
        );
        Memorize(
            2017,
            12,
            17,
            address(0x08A9eAD5bD9Af49A1F777A9f15929871ABD684C3)
        );
        Memorize(
            2017,
            12,
            18,
            address(0x08A9eAD5bD9Af49A1F777A9f15929871ABD684C3)
        );
        Memorize(
            2017,
            12,
            19,
            address(0xE920Ba2D30e812fCb02004B0253ebe168c623C66)
        );
        Memorize(
            2017,
            12,
            20,
            address(0x534A0076fb7c2b1f83FA21497429AD7ad3bD7587)
        );
        Memorize(
            2017,
            12,
            21,
            address(0x269616D549D7e8Eaa82DFb17028d0B212D11232A)
        );
        Memorize(
            2017,
            12,
            22,
            address(0x3924b7681c6110fCd3628164388c3307F79d1059)
        );
        Memorize(
            2017,
            12,
            23,
            address(0xA9d748A28A713Ecc751de04fEe994f3BC1f19Eb7)
        );
        Memorize(
            2017,
            12,
            24,
            address(0x48D9d0Eabc945Aa513a52d71e0Ea4047B2c33Ce4)
        );
        Memorize(
            2017,
            12,
            25,
            address(0x232968098eC98DAbC4A8A8fa9eB39a7666516006)
        );
        Memorize(
            2017,
            12,
            26,
            address(0xf3B0f4411C77c60A132003DbC01D58Fe137B75ae)
        );
        Memorize(
            2017,
            12,
            27,
            address(0x6639C089AdFbA8bb9968dA643C6BE208a70d6daA)
        );
        Memorize(
            2017,
            12,
            28,
            address(0xD6f487c29bE27DAeC9b4C44aA37D5e0902266a5B)
        );
        Memorize(
            2017,
            12,
            29,
            address(0x484c6DcD50978B9D525cC20a02d5801F492931F8)
        );
        Memorize(
            2017,
            12,
            30,
            address(0xa9D9dF8013B7cf2bcE0Dd5Ed8F34f468cDdDF28a)
        );
        //Initial airdrop invite
        _airdrop[address(0x21Ff39cFDBAfdc05591c8185d85D12695398e488)] = 1;
        _airdrop[address(0xB6CC633518147bBcD4320cAaF9b1400ca87837E1)] = 1;
        _airdrop[address(0xB98ec5003091eF506C5D79e961Ae79C48b88249B)] = 1;
        _airdrop[address(0x998054544099C4f22bBC405dC69Faa2e1be0b119)] = 1;
        _airdrop[address(0xf0E22d00cBa59Ec1CdA9a77B044518A9F1bC407B)] = 1;
        _airdrop[address(0x9791b25aAC86d0011740538Bce52A3b4cBcfdEC0)] = 1;
        _airdrop[address(0x33DC5F65C6Cd6A8171af1f10BbbE777E59E77912)] = 1;
        _airdrop[address(0x0027f9364BDE43D777A7B2c34ca4900E9e331467)] = 1;
        _airdrop[address(0x1204C63555B854915cDc24DE20c699fE6C59FA3D)] = 1;
        _airdrop[address(0x7FDF4DCb420297168F6E8CA4E8F1C44D93aD2600)] = 1;
        _airdrop[address(0xB24E97EACA9484f36A043A42C48517D63a08f63A)] = 1;
        _airdrop[address(0x00De12d41f7E578035876EF019fe916f2Dbe5a72)] = 1;
        _airdrop[address(0xAFE71c4CdF6949cAE968A2E9A7C1172412A8bb2f)] = 1;
        _airdrop[address(0x69296bF0cFBEc2fD2E28566c05fe90879dc9f27C)] = 1;
        _airdrop[address(0x9b2620b0C0d2A5c38b1f3D1DF88224033263A6aE)] = 1;
        _airdrop[address(0x3578B6A55f086F615F3b0D8957DD4a39ee5Faf4A)] = 1;
        _airdrop[address(0xF34cBE3CA35Ed691d47CF37761571f7F292577F2)] = 1;
        _airdrop[address(0xf1F02EF0570d2849198785D2204f94A64aaccBb5)] = 1;
        _airdrop[address(0x53062093eFaB210868c0D6Af9697a47a689E0Eba)] = 1;
        _airdrop[address(0xea54e8c4DB742a7bD8aDc8bCf4E78716baCc7484)] = 1;
    }
}
