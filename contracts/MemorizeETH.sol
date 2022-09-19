// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MemorizeThisDay.sol";

contract MemorizeThisDayOnETH is MemorizeThisDay {
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
            "Ethereum",
            "https://memorizethisday.github.io/ETH/{id}.json",
            90,
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
            address(0x55665168CCef2cDfcD29fe4a1CFCD803Ea4AA76e)
        );
        Memorize(
            2017,
            12,
            2,
            address(0x77f6821146CCe5993282d940eEf472c4B09d7537)
        );
        Memorize(
            2017,
            12,
            3,
            address(0x77f6821146CCe5993282d940eEf472c4B09d7537)
        );
        Memorize(
            2017,
            12,
            4,
            address(0x42Cc1648D82DCA041c5B737C52F8b70c4192a396)
        );
        Memorize(
            2017,
            12,
            5,
            address(0x77f6821146CCe5993282d940eEf472c4B09d7537)
        );
        Memorize(
            2017,
            12,
            6,
            address(0x6714094155BE5878aaEA801a5a34B101670908A3)
        );
        Memorize(
            2017,
            12,
            7,
            address(0xDf6d32981752C438a8AdFc801576e4e4dAc204C0)
        );
        Memorize(
            2017,
            12,
            8,
            address(0x0b28D49CdF9A44b6E07a44ACc84FcEc4F1768265)
        );
        Memorize(
            2017,
            12,
            9,
            address(0x41728765acB49C0f94c434C286ab6518cb94bCdb)
        );
        Memorize(
            2017,
            12,
            10,
            address(0x494eb06758e268aF745CC3133b6F5f6e8b9EcB33)
        );
        Memorize(
            2017,
            12,
            11,
            address(0x7190a9b17B7d79dBBc2F7316A665f6A494E7d717)
        );
        Memorize(
            2017,
            12,
            12,
            address(0xDf6d32981752C438a8AdFc801576e4e4dAc204C0)
        );
        Memorize(
            2017,
            12,
            13,
            address(0xc5682CBe9849efa6fA6ea0B63589b3a9484E3992)
        );
        Memorize(
            2017,
            12,
            14,
            address(0x989A5d65720E62D80299747e5a95024ff07732fF)
        );
        Memorize(
            2017,
            12,
            15,
            address(0x9495A381742eC74D569eA4368586400ee20e3Ae3)
        );
        Memorize(
            2017,
            12,
            16,
            address(0x21A6D0817074d9E302e2EdacC4CdC08689003fAa)
        );
        Memorize(
            2017,
            12,
            17,
            address(0xC55D765bbd35e495eA519F0A170dedd30363e114)
        );
        Memorize(
            2017,
            12,
            18,
            address(0x30b941418A71565980434CdE8692dbBc1fdB70EB)
        );
        Memorize(
            2017,
            12,
            19,
            address(0xbBc92cC8C8b73daAEDFEC30c01DAD525f52B7c29)
        );
        Memorize(
            2017,
            12,
            20,
            address(0xa671041Fd8058De2Cde34250dfAc7E3a858B50f1)
        );
        Memorize(
            2017,
            12,
            21,
            address(0xbBc92cC8C8b73daAEDFEC30c01DAD525f52B7c29)
        );
        Memorize(
            2017,
            12,
            22,
            address(0xf9C461556f54be8DA0855CB0a0373e9E80d5C0B7)
        );
        Memorize(
            2017,
            12,
            23,
            address(0x9FFbD8B17F6b058849A853780D5bB6e411984A88)
        );
        Memorize(
            2017,
            12,
            24,
            address(0x355c0d364caA4B8c212a6F96763a59b5c704b512)
        );
        Memorize(
            2017,
            12,
            25,
            address(0xae2e041390E3DF2ba88fB1120Df3b65CF1a41436)
        );
        Memorize(
            2017,
            12,
            26,
            address(0x2977D71dba485792B0fF294601E444460D913a58)
        );
        Memorize(
            2017,
            12,
            27,
            address(0xF561266D093c73F67c7CAA2Ab74CC71a43554e57)
        );
        Memorize(
            2017,
            12,
            28,
            address(0x8464da2C737DfE5B55c0D4BE69Fa7E84eB2249BE)
        );
        Memorize(
            2017,
            12,
            29,
            address(0xC6e3C5fF24f653AF55D60154e7E7369e6e24Aa48)
        );
        Memorize(
            2017,
            12,
            30,
            address(0x620b70123fB810F6C653DA7644b5dD0b6312e4D8)
        );

        //Initial airdrop invite

        _airdrop[address(0xA87F95f895F4d18b0Adc4848cb690AD326044B7c)] = 1;
        _airdrop[address(0x0c242DC23931Eca5ae3bc7c074F2a2dF556F4Bf5)] = 1;
        _airdrop[address(0x09bd8762310e75E7a747be56Da85434E13fe42Be)] = 1;
        _airdrop[address(0x7B25De321f6557439E595bcc4f0AcaAA38479e72)] = 1;
        _airdrop[address(0xb41f4830EC12f4AE7df642D72DA1940396df8cbb)] = 1;
        _airdrop[address(0x61016CB8ddc2EE5958dcf057580A1cC1f1f68294)] = 1;
        _airdrop[address(0x81f6B5d812872C0C2608A24bCC987a6A86dF15F8)] = 1;
        _airdrop[address(0xb85a1D16644220aD7ce99eCe9Fe3B5c7F4697453)] = 1;
        _airdrop[address(0xCAFC2FF0b43DFFa5e0cA27EA6566C144CF025326)] = 1;
        _airdrop[address(0xbA8740051613cAf78C5330569E878b93e1b5C1af)] = 1;
        _airdrop[address(0xcFFED8e8Fa2e67B2a7af86fD115c44A364cd134e)] = 1;
        _airdrop[address(0x840183b2a28317Aa66bF013C179b17d1F3264dEc)] = 1;
        _airdrop[address(0x03Db8645Eb70C4a26EFD00C073de4fDF0BA6c139)] = 1;
        _airdrop[address(0x68F5Fb1DD0a0FA3C2b71f562799668F1c5F86307)] = 1;
        _airdrop[address(0xbd0eFF8be49764685454Cf5c772118E8EA5b421e)] = 1;
        _airdrop[address(0x084b7DC6a05E45B4dbBB2D8e2DecE125CCDE9Ec2)] = 1;
        _airdrop[address(0x8AacF41c549be913EF7D3776d31564ec1311EaAD)] = 1;
        _airdrop[address(0x5d88Dd2a1aa216c54F79F74ed8447C7256911618)] = 1;
        _airdrop[address(0x8D4F129b39C9fE20092778b13a3813e0D7c0963D)] = 1;
        _airdrop[address(0x38afF03b0C7d288838562737084129c1B69fE4AB)] = 1;
    }
}
