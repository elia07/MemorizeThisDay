// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MemorizeThisDay.sol";

contract MemorizeThisDayOnLINK is MemorizeThisDay {
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
            "ChainLink",
            "https://memorizethisday.github.io/LINK/{id}.json",
            80,
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
            address(0x9d0C6f7b2867B8F7d27f06587263ab1c240Db626)
        );
        Memorize(
            2017,
            12,
            2,
            address(0x5A744ce4DAf9cc5C797E76AFFE023Deae9abc7cf)
        );
        Memorize(
            2017,
            12,
            3,
            address(0xDA0Da0Da0Da0a77740bB62c5c9D45423533d0CE2)
        );
        Memorize(
            2017,
            12,
            4,
            address(0x8dd6C4bD737966aaA05E8Eb2588E56B6165F7e73)
        );
        Memorize(
            2017,
            12,
            5,
            address(0xed3A3A50c4Edc40cE6B81A8f0aBff71742f22CE2)
        );
        Memorize(
            2017,
            12,
            6,
            address(0x09FABf8c79e141FEa3B87629a19C1deFef0B9291)
        );
        Memorize(
            2017,
            12,
            7,
            address(0x3Bb08118B2Da7aE1344a42bBdDF7636b03357792)
        );
        Memorize(
            2017,
            12,
            8,
            address(0xFC906618a0F946EfC68ad3957B8a26416617DdD7)
        );
        Memorize(
            2017,
            12,
            9,
            address(0x5D8A282e41879AfBF13B19637E17235bD19B9E7b)
        );
        Memorize(
            2017,
            12,
            10,
            address(0xE3DBc37f19C9496c81c6e19D656029a607193Cf8)
        );
        Memorize(
            2017,
            12,
            11,
            address(0xD44CC0980d4C04718b460BCa851834F103d25F81)
        );
        Memorize(
            2017,
            12,
            12,
            address(0x77dAd50E2978e356414301D3b600B15604c0C7fd)
        );
        Memorize(
            2017,
            12,
            13,
            address(0x3AE85D19566C1daCea625B2909E07a6f4b72FfB3)
        );
        Memorize(
            2017,
            12,
            14,
            address(0xDe8A55a9c4D4965Eae6C5C02C92A5C1A0E675276)
        );
        Memorize(
            2017,
            12,
            15,
            address(0xD3C7BcB6f657ae356efc8a7B69134D71206Cabf9)
        );
        Memorize(
            2017,
            12,
            16,
            address(0xC6c60fDC5B2379AABC853D45eBEB12aF7FC63841)
        );
        Memorize(
            2017,
            12,
            17,
            address(0xcceadC23117995fDa452225E6B6435c68ef10670)
        );
        Memorize(
            2017,
            12,
            18,
            address(0x4b2289A61A5Fee9d8E7Fd1962335Ec6086fe58E1)
        );
        Memorize(
            2017,
            12,
            19,
            address(0x465C685Ea8265BC41F970F3436821EAacCDd7A53)
        );
        Memorize(
            2017,
            12,
            20,
            address(0x22871d53dDa2aEBDaD96272197E7cC52F81e92FD)
        );
        Memorize(
            2017,
            12,
            21,
            address(0xe18A94A1e60903B1EC39d9104bed27d9A73ad9e2)
        );
        Memorize(
            2017,
            12,
            22,
            address(0x1979AE5f11170068da75C48F1D837C76C213C1F1)
        );
        Memorize(
            2017,
            12,
            23,
            address(0x00B41cB7F22fCd64132a8f5E693847acBF351dA4)
        );
        Memorize(
            2017,
            12,
            24,
            address(0x55337EabAFb3f82Fd4eFd5D0505DDcEEbE7C48A8)
        );
        Memorize(
            2017,
            12,
            25,
            address(0xbC1934f548417f79ab10138B57716Fbc7C25c177)
        );
        Memorize(
            2017,
            12,
            26,
            address(0xEaA1cE24311Ef6f0444D80CF47369952a28c5503)
        );
        Memorize(
            2017,
            12,
            27,
            address(0xF928EDae51f0110c390346F1c50c5586bfe24746)
        );
        Memorize(
            2017,
            12,
            28,
            address(0x88Ffef0aFe41b123BeCB131BD8357e52c1C31DEa)
        );
        Memorize(
            2017,
            12,
            29,
            address(0xE302B0fd3C0DA272dFa99aBd91b69566C63252C4)
        );
        Memorize(
            2017,
            12,
            30,
            address(0xcF1f993adD8c0F080E340D8DF277B508351DE5d8)
        );

        //Initial airdrop invite
        _airdrop[address(0x579AC50e7F43D60D179AbEC3d65d9227Fe762cB3)] = 1;
        _airdrop[address(0xE9C865914baC7085F88121dAAB5E46b51cfA600F)] = 1;
        _airdrop[address(0x543174CbbCDa94040aD50ec5c32be9Fd9C9ed22e)] = 1;
        _airdrop[address(0xae637302d2E2fa41ABa478668231bE14212F85B3)] = 1;
        _airdrop[address(0x6400e390D8e6e2F79Ae8Bf8A67F9df06B8E94424)] = 1;
        _airdrop[address(0x76e4261085F5e3A7a5B629FeA2Ba2067519EA073)] = 1;
        _airdrop[address(0xCb3efA36E846B3867520D092ea907807f43f029b)] = 1;
        _airdrop[address(0xec8C2ba557fa11c6881117a3158231C6077F4f08)] = 1;
        _airdrop[address(0x9573cf56742F4681EcFa1C7045e3fD29DDA5e9B8)] = 1;
        _airdrop[address(0x3817c924FB592E9058F09Bf90a6969C0E529F15a)] = 1;
        _airdrop[address(0x2A6B15CF0B4c07D252a1eee4a081630656A93f62)] = 1;
        _airdrop[address(0xe3683722063f0485eC79036E28E8e097241F8B53)] = 1;
        _airdrop[address(0xdfa0f74353535777c98779ab3f1BE7B0ff279917)] = 1;
        _airdrop[address(0x7F0bFF832D15772b726CFd964749c5cb141D9f94)] = 1;
        _airdrop[address(0xAE5b81BEF4BFbe936b121d807147C643D4a7044c)] = 1;
        _airdrop[address(0xE360E82535342705DEb0e2e32A57Fda5FcaC766c)] = 1;
        _airdrop[address(0x1133bd6B1eE76D9E78A881951532b1525e17B553)] = 1;
        _airdrop[address(0xb6d566CfE1A4820ca6367FAF02a8CA1b7e4a1dE1)] = 1;
        _airdrop[address(0x52bff00394bF712BE5F777dc7de22888A282dbE5)] = 1;
        _airdrop[address(0x0Fe426837B07e97097aaca314E95c6602828C702)] = 1;
    }
}
