// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MemorizeThisDay.sol";

contract MemorizeThisDayOnSHIB is MemorizeThisDay {
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
            "Shiba Inu",
            "https://memorizethisday.github.io/SHIB/{id}.json",
            60,
            vrfCoordinator,
            linkToken,
            chainlinkFee,
            keyHash,
            priceFeedAddress,
            2021,
            4,
            16
        )
    {
        SetAddress(founderAddress, 0);
        SetAddress(developersAddress, 1);
        _airdrop[founderAddress] = 24;
        Memorize(2021, 4, 16, developersAddress);
        Memorize(2021, 4, 17, developersAddress);
        Memorize(2021, 4, 18, developersAddress);
        Memorize(2021, 4, 19, developersAddress);
        Memorize(2021, 4, 20, developersAddress);
        Memorize(2021, 4, 21, developersAddress);
        Memorize(2021, 4, 22, developersAddress);
        Memorize(2021, 4, 23, developersAddress);

        Memorize(2021, 4, 24, founderAddress);
        Memorize(2021, 4, 25, founderAddress);
        Memorize(2021, 4, 26, founderAddress);
        Memorize(2021, 4, 27, founderAddress);

        //Initial invites to our community
        Memorize(
            2021,
            5,
            1,
            address(0x8B804fbd998f612c2B98Fb81B06D993008d1bF09)
        );
        Memorize(
            2021,
            5,
            2,
            address(0x3144ac9CE763c919551B0e3F871A6c317f779733)
        );
        Memorize(
            2021,
            5,
            3,
            address(0x4172Ef0607568912dc032a0E660BFa2Ffc9fb0F0)
        );
        Memorize(
            2021,
            5,
            4,
            address(0x4172Ef0607568912dc032a0E660BFa2Ffc9fb0F0)
        );
        Memorize(
            2021,
            5,
            5,
            address(0xBFfDb82557697700fC10638Be62F32cE40c9E480)
        );
        Memorize(
            2021,
            5,
            6,
            address(0x98BB4Ac8AE0eD9EEF95a7681BdA3161b928d34EC)
        );
        Memorize(
            2021,
            5,
            7,
            address(0x905Bfc1388a5e68a7203501eFffC1e262bdBA432)
        );
        Memorize(
            2021,
            5,
            8,
            address(0xEB734e26dc36C06D601f27D9B374E2Bf47dE26bB)
        );
        Memorize(
            2021,
            5,
            9,
            address(0x0a0c99c370A0dbB04001e9fE57746768b9619b93)
        );
        Memorize(
            2021,
            5,
            10,
            address(0x40a5168566a8088753Ba94Dd45181d205074Bd81)
        );
        Memorize(
            2021,
            5,
            11,
            address(0xA422bfFF5dABa6eeeFAFf84Debf609Edf0868C5f)
        );
        Memorize(
            2021,
            5,
            12,
            address(0x0Bff542b566104ED68e3dB8b78EB33DB795ceA99)
        );

        //Initial airdrop invite
        _airdrop[address(0x7E407c3AdE98F172c051094C83f656D83680241a)] = 1;
        _airdrop[address(0x326B7770eDdf63d124238909B11Ca9281aCe0650)] = 1;
        _airdrop[address(0xEDd67164eF8206aE8fdb9119491Cc23D9622901b)] = 1;
        _airdrop[address(0xBEA353b19460e72fff596CE7664091cFb53Da31a)] = 1;
        _airdrop[address(0xC6ED413c311982080aCbA6931635aeC48F2398CC)] = 1;
        _airdrop[address(0xAf62a9b4F857c3509C3060f9d2394c36d1887B96)] = 1;
        _airdrop[address(0xcBb78A25cC3be0E5e5d0e5344e3B899CA100c31E)] = 1;
        _airdrop[address(0x398f418EC768f6de8a73563788411Cf23105cCac)] = 1;
        _airdrop[address(0x6DfaC661E14AD1Cc428011f860bb3BD5b28237Fb)] = 1;
        _airdrop[address(0x5EfeC645cac3299d2744301edCc16cCF083E8AB8)] = 1;
        _airdrop[address(0x90d4263A7b7E58e353aBabb06C973dC214FA74f6)] = 1;
        _airdrop[address(0x388C3D822e7E217C31927d7f8cb70A4d48A49C9C)] = 1;
    }
}
