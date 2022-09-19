// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BokkyPooBahsDateTimeLibrary.sol";
import "./strings.sol";

abstract contract MemorizeThisDay is ERC1155Pausable, Ownable, VRFConsumerBase {
    //ENUMS
    enum VAULT_ACTION {
        HODL,
        DistributeOverMembers,
        DistributeOverElders,
        HelpDevelopment,
        WithdrawalToAmbassador
    }
    //END of ENUMS

    //Modifiers
    modifier onlyElectoral() {
        require(msg.sender == _ambassador || msg.sender == owner(), "e1");
        _;
    }

    //End of Modifiers

    //Const

    uint256 private constant VAULT_V1 = 1;
    uint256 private constant VAULT_V2 = 2;
    uint256 private constant VAULT_V3 = 3;
    uint256 private constant VAULT_DEVELOPMENT = 4;
    uint256 private constant MIN_SPONSORSHIP_PERIODINDAYS = 30;
    uint256 private constant AMBASSADOR_TOKEN_ID = 1;
    uint256 private constant SPONSOR_TOKEN_ID = 2;
    uint256 private constant MIN_WITHDRAWAL = 0.01 ether;
    //MintingShares
    uint256 public constant DEVELOPMENT_VAULT_SHARE = 25;
    uint256 public constant METADATAFORGER_VAULT_SHARE = 5;
    uint256 public constant FOUNDER_SHARE = 5;
    uint256 public constant AMBASSADOR_SHARE = 5;
    uint256 public constant VAULT_1_SHARE = 30;
    uint256 public constant VAULT_2_SHARE = 30;
    //Total 100%

    //Vars
    string public _UrlStartWith = "https://gateway.pinata.cloud/ipfs/";
    bytes32 private requestId;
    address public _ambassador;
    uint256 public _ambassadorDay;
    uint256 public _nextAmbassadorDay;
    address public _lastLotteryWinner;

    AggregatorV3Interface internal _priceFeedAddress;
    string public _assetName;
    uint256 public _mintPriceStep = 0;
    bool public _invitePeriod = true;
    uint256 public _eldersRemaining = 1000;

    bool public _isSponsorshipAccepted = false;
    address public _sponsorAddress = address(0);
    string public _sponsorTitle = "";
    string public _sponsorTwitter = "";
    string public _sponsorURL = "";
    string public _sponsorImage = "";
    uint256 public _sponsorShipLockUntil = 0;
    uint256 public _mintPrice = 0;
    uint256 public _initialPrice = 0;
    address[] public _periodicAirdropRegisters;
    uint256 public _airdropPeriodInDays = 7;
    uint256 public _electoralAirdropPeriodInDays = 7;
    uint256 public _lastAirdropPeriodWinnerSelectDate;
    uint256 public _lastElectoralAirdropDate;
    uint256 public _startDate;
    uint256 public _lastMemorizeDate;
    uint256 public _lastElectionDate;
    uint256[] public _mintedDays;
    uint256 public _chainlinkFee;
    bytes32 _keyHash;

    //Events
    event WithdrawalEvent(address indexed _address, uint256 indexed _amount);
    event PeriodicAirdropWinnerSelectedEvent(
        address indexed _address,
        uint256 randomness
    );
    event MemorizedEvent(
        uint256 year,
        uint256 month,
        uint256 day,
        address indexed holder
    );
    event LikeEvent(
        uint256 indexed year,
        uint256 indexed month,
        uint256 indexed day
    );
    event ChangeAmbassadorEvent(
        address indexed previous,
        address indexed current
    );
    event CustomizeEvent(
        uint256 indexed year,
        uint256 indexed month,
        uint256 indexed day
    );
    event VoteResult(uint256 indexed vaultNumber, VAULT_ACTION indexed action);
    //END of Events

    //Addresses
    address public _metadataForgerAddress;
    address public _founderAddress;
    address[5] public _vaultsAddress;
    //End of Addresses

    //Mappings
    mapping(address => uint256) public _wallet;
    mapping(address => uint256) public _airdrop;
    mapping(uint256 => address) public _holders;
    mapping(uint256 => uint256) public _likes;
    mapping(uint256 => bool) public _elders;
    mapping(address => bool) public _InitialElders;
    mapping(uint256 => uint256) public _eldersIndex;
    address[] public _eldersAddress;
    mapping(uint256 => string) public _memo;
    mapping(uint256 => string) public _imageMemo;
    mapping(address => string) public _alias;
    mapping(uint256 => string) public _twitterAccount;

    mapping(uint256 => address) public _ambasaddorVotes;
    mapping(address => uint256) public _ambassadorVotesAggregate;
    address public _nextAmbassador;

    mapping(uint256 => mapping(uint256 => VAULT_ACTION)) public _Votes;
    mapping(uint256 => mapping(VAULT_ACTION => uint256)) public _VotesAggregate;

    //End of Mappings

    //Errors
    error WrongDaySelection(uint256, uint256);

    //End of Errors

    constructor(
        string memory assetName,
        string memory baseURI,
        uint256 mintPrice,
        address vrfCoordinator,
        address linkToken,
        uint256 chainlinkFee,
        bytes32 keyHash,
        address priceFeedAddress,
        uint256 startYear,
        uint256 startMonth,
        uint256 startDay
    ) VRFConsumerBase(vrfCoordinator, linkToken) ERC1155(baseURI) {
        _mintPrice = mintPrice * (10**18);
        _initialPrice = _mintPrice;
        _mintPriceStep = (10**18);
        _chainlinkFee = chainlinkFee;
        _keyHash = keyHash;
        _lastAirdropPeriodWinnerSelectDate = BokkyPooBahsDateTimeLibrary
            .subDays(block.timestamp, 8);
        _lastElectoralAirdropDate = BokkyPooBahsDateTimeLibrary.subDays(
            block.timestamp,
            8
        );
        _lastElectionDate = BokkyPooBahsDateTimeLibrary.subDays(
            block.timestamp,
            30
        );

        _assetName = assetName;

        _vaultsAddress[VAULT_V1] = address(1);
        _vaultsAddress[VAULT_V2] = address(2);
        _vaultsAddress[VAULT_V3] = address(3);
        _vaultsAddress[VAULT_DEVELOPMENT] = address(4);
        _ambassador = address(0);

        _priceFeedAddress = AggregatorV3Interface(priceFeedAddress);

        _startDate = BokkyPooBahsDateTimeLibrary.timestampFromDate(
            startYear,
            startMonth,
            startDay
        );
        _sponsorShipLockUntil = _startDate;
    }

    function GetMemorizeFee() public view returns (uint256) {
        (, int256 price, , , ) = _priceFeedAddress.latestRoundData();
        return (_mintPrice * 10**18) / (uint256(price) * 10**10);
    }

    function Memorize(
        uint256 year,
        uint256 month,
        uint256 day,
        address giftTo
    ) public payable whenNotPaused {
        require(!(month <= 0 || month > 12), "e3");
        require(!(day <= 0 || day > 31), "e4");
        if (
            ((month == 4 || month == 6 || month == 9 || month == 11) &&
                day > 30) ||
            (month == 2 &&
                BokkyPooBahsDateTimeLibrary._isLeapYear(year) &&
                day > 29) ||
            (month == 2 &&
                !BokkyPooBahsDateTimeLibrary._isLeapYear(year) &&
                day > 28)
        ) {
            revert WrongDaySelection(month, day);
        }

        uint256 _dayNumber = BokkyPooBahsDateTimeLibrary.timestampFromDate(
            year,
            month,
            day
        );

        require(
            _dayNumber <= block.timestamp && _dayNumber >= _startDate,
            "e5"
        );
        require(_holders[_dayNumber] == address(0), "e6");
        if (giftTo == address(0)) {
            giftTo = msg.sender;
        }
        bool useAirdrop = false;
        if (_invitePeriod && _InitialElders[msg.sender] == false) {
            _airdrop[msg.sender] += 1;
        }
        if (_airdrop[msg.sender] > 0) {
            useAirdrop = true;
            _airdrop[msg.sender] = _airdrop[msg.sender] - 1;
            if (_eldersRemaining > 0) {
                _eldersRemaining = _eldersRemaining - 1;
                _elders[_dayNumber] = true;
                _InitialElders[msg.sender] = true;
                _eldersAddress.push(msg.sender);
                _eldersIndex[_dayNumber] = _eldersAddress.length - 1;
                if (_eldersRemaining == 0) {
                    _invitePeriod = false;
                }
            }
        }

        if (!useAirdrop) {
            require(msg.value >= GetMemorizeFee(), "e7");

            uint256 founderShare = (msg.value * FOUNDER_SHARE) / 100;
            _wallet[_founderAddress] = _wallet[_founderAddress] + founderShare;

            uint256 ambassadorShare = (msg.value * AMBASSADOR_SHARE) / 100;
            if (_ambassador == address(0)) {
                _wallet[_metadataForgerAddress] =
                    _wallet[_metadataForgerAddress] +
                    ambassadorShare;
            } else {
                _wallet[_ambassador] = _wallet[_ambassador] + ambassadorShare;
            }

            uint256 forgerShare = (msg.value * METADATAFORGER_VAULT_SHARE) /
                100;
            _wallet[_metadataForgerAddress] =
                _wallet[_metadataForgerAddress] +
                forgerShare;

            uint256 developmentShare = (msg.value * DEVELOPMENT_VAULT_SHARE) /
                100;
            _wallet[_vaultsAddress[VAULT_DEVELOPMENT]] =
                _wallet[_vaultsAddress[VAULT_DEVELOPMENT]] +
                developmentShare;

            uint256 vault1Share = (msg.value * VAULT_1_SHARE) / 100;
            _wallet[_vaultsAddress[VAULT_V1]] =
                _wallet[_vaultsAddress[VAULT_V1]] +
                vault1Share;

            uint256 vault2Share = (msg.value * VAULT_2_SHARE) / 100;
            _wallet[_vaultsAddress[VAULT_V2]] =
                _wallet[_vaultsAddress[VAULT_V2]] +
                vault2Share;
        }

        _mint(giftTo, _dayNumber, 1, "");
        _mintedDays.push(_dayNumber);
        _holders[_dayNumber] = giftTo;
        _lastMemorizeDate = block.timestamp;

        for (uint256 i = 1; i <= 3; i++) {
            if (!_elders[_dayNumber] && i == 3) {
                continue;
            }
            _VotesAggregate[i][VAULT_ACTION.HelpDevelopment] =
                _VotesAggregate[i][VAULT_ACTION.HelpDevelopment] +
                VotePower(year, month, day);
            _Votes[i][_dayNumber] = VAULT_ACTION.HelpDevelopment;
        }

        if (!useAirdrop) {
            _mintPrice = _mintPrice + _mintPriceStep;
        }
        emit MemorizedEvent(year, month, day, giftTo);
    }

    function AcceptSponsorship(bool acceptance) public onlyElectoral {
        uint256 totalDaysRequest = (_wallet[_sponsorAddress] /
            GetMemorizeFee()) * 4;
        if (totalDaysRequest < MIN_SPONSORSHIP_PERIODINDAYS) {
            acceptance = false;
        }
        if (acceptance) {
            _isSponsorshipAccepted = true;
            _wallet[_vaultsAddress[VAULT_V3]] =
                _wallet[_vaultsAddress[VAULT_V3]] +
                _wallet[_sponsorAddress];
            _wallet[_sponsorAddress] = 0;
            _sponsorShipLockUntil = BokkyPooBahsDateTimeLibrary.addDays(
                block.timestamp,
                totalDaysRequest
            );
            _mint(_sponsorAddress, SPONSOR_TOKEN_ID, 1, "");
        } else {
            _sponsorAddress = address(0);
            _isSponsorshipAccepted = false;
            _sponsorShipLockUntil = block.timestamp;
            _sponsorTitle = "";
            _sponsorTwitter = "";
            _sponsorURL = "";
            _sponsorImage = "";
        }
    }

    function RequestSponsorship(
        string memory title,
        string memory url,
        string memory imageurl,
        string memory twitter
    ) public payable whenNotPaused {
        require(bytes(title).length <= 50, "e36");
        require(_sponsorAddress == address(0), "e8");
        require(block.timestamp >= _sponsorShipLockUntil, "e9");
        uint256 totalDaysRequest = ((msg.value + _wallet[msg.sender]) /
            GetMemorizeFee()) * 4;
        require(totalDaysRequest >= MIN_SPONSORSHIP_PERIODINDAYS, "e10");
        _sponsorAddress = msg.sender;
        _wallet[_sponsorAddress] = _wallet[_sponsorAddress] + msg.value;

        _sponsorTitle = title;
        _sponsorTwitter = twitter;
        _sponsorURL = url;
        _sponsorImage = imageurl;
        _isSponsorshipAccepted = false;
    }

    function Like(
        uint256 year,
        uint256 month,
        uint256 day
    ) public {
        uint256 _dayNumber = BokkyPooBahsDateTimeLibrary.timestampFromDate(
            year,
            month,
            day
        );
        require(_holders[_dayNumber] != address(0), "e11");
        _likes[_dayNumber] = _likes[_dayNumber] + 1;
        emit LikeEvent(year, month, day);
    }

    function VotePower(
        uint256 year,
        uint256 month,
        uint256 day
    ) public view returns (uint256) {
        uint256 _dayNumber = BokkyPooBahsDateTimeLibrary.timestampFromDate(
            year,
            month,
            day
        );
        require(_holders[_dayNumber] != address(0), "e11");
        uint256 votingPower = (
            BokkyPooBahsDateTimeLibrary.diffYears(_dayNumber, block.timestamp)
        );
        if (_elders[_dayNumber]) {
            votingPower = votingPower * 4;
        }
        if (votingPower <= 0) {
            votingPower = 1;
        }
        return votingPower;
    }

    function Vote(
        uint256 year,
        uint256 month,
        uint256 day,
        uint256 ambassadoryear,
        uint256 ambassadormonth,
        uint256 ambassadorday,
        VAULT_ACTION[] memory action
    ) public whenNotPaused {
        uint256 _dayNumber = BokkyPooBahsDateTimeLibrary.timestampFromDate(
            year,
            month,
            day
        );
        require(_holders[_dayNumber] != address(0), "e11");
        require(_holders[_dayNumber] == msg.sender, "e12");
        uint256 votingPower = VotePower(year, month, day);

        for (uint256 i = 1; i <= 3; i++) {
            if (i == 3 && !_elders[_dayNumber]) {
                continue;
            }
            if (_Votes[i][_dayNumber] != action[i - 1]) {
                if (_VotesAggregate[i][_Votes[i][_dayNumber]] > 0) {
                    _VotesAggregate[i][_Votes[i][_dayNumber]] =
                        _VotesAggregate[i][_Votes[i][_dayNumber]] -
                        votingPower;
                }

                _VotesAggregate[i][action[i - 1]] =
                    _VotesAggregate[i][action[i - 1]] +
                    votingPower;
                _Votes[i][_dayNumber] = action[i - 1];
            }
        }
        if (ambassadoryear != 0 && ambassadormonth != 0 && ambassadorday != 0) {
            uint256 ambassadordayIndex = BokkyPooBahsDateTimeLibrary
                .timestampFromDate(
                    ambassadoryear,
                    ambassadormonth,
                    ambassadorday
                );
            address suggestedAmbasaddor = _holders[ambassadordayIndex];
            require(
                !strings.compareStrings(
                    _twitterAccount[ambassadordayIndex],
                    ""
                ),
                "e35"
            );
            if (
                suggestedAmbasaddor != address(0) &&
                _ambasaddorVotes[_dayNumber] != suggestedAmbasaddor
            ) {
                if (
                    _ambassadorVotesAggregate[_ambasaddorVotes[_dayNumber]] > 0
                ) {
                    _ambassadorVotesAggregate[_ambasaddorVotes[_dayNumber]] =
                        _ambassadorVotesAggregate[
                            _ambasaddorVotes[_dayNumber]
                        ] -
                        votingPower;
                }

                _ambassadorVotesAggregate[suggestedAmbasaddor] =
                    _ambassadorVotesAggregate[suggestedAmbasaddor] +
                    votingPower;
                _ambasaddorVotes[_dayNumber] = suggestedAmbasaddor;

                if (
                    _ambassadorVotesAggregate[suggestedAmbasaddor] >
                    _ambassadorVotesAggregate[_nextAmbassador]
                ) {
                    _nextAmbassador = suggestedAmbasaddor;
                    _nextAmbassadorDay = BokkyPooBahsDateTimeLibrary
                        .timestampFromDate(
                            ambassadoryear,
                            ambassadormonth,
                            ambassadorday
                        );
                }
            }
        }
    }

    function ElectionThreshold() public view returns (uint256) {
        if (_mintedDays.length <= _eldersAddress.length) {
            return
                ((_mintedDays.length * 25) / 100) *
                BokkyPooBahsDateTimeLibrary.diffYears(
                    _startDate,
                    block.timestamp
                ) *
                4;
        } else {
            return
                ((_mintedDays.length * 25) / 100) *
                BokkyPooBahsDateTimeLibrary.diffYears(
                    _startDate,
                    block.timestamp
                ) +
                (_eldersAddress.length * 4);
        }
    }

    function Election() public whenNotPaused {
        require(
            BokkyPooBahsDateTimeLibrary.diffDays(
                _lastElectionDate,
                block.timestamp
            ) >= 30,
            "e13"
        );
        uint256 acceptanceThreshold = ElectionThreshold();
        require(
            _ambassadorVotesAggregate[_nextAmbassador] >= acceptanceThreshold,
            "e14"
        );

        if (_nextAmbassador != _ambassador) {
            emit ChangeAmbassadorEvent(_ambassador, _nextAmbassador);
            _ambassador = _nextAmbassador;
            _ambassadorDay = _nextAmbassadorDay;
            _mint(_ambassador, AMBASSADOR_TOKEN_ID, 1, "");
        }
        for (uint256 i = 1; i <= 3; i++) {
            uint256[5] memory actionVotes;

            actionVotes[0] = _VotesAggregate[i][VAULT_ACTION.HODL];
            actionVotes[1] = _VotesAggregate[i][
                VAULT_ACTION.DistributeOverMembers
            ];
            actionVotes[2] = _VotesAggregate[i][
                VAULT_ACTION.DistributeOverElders
            ];
            actionVotes[3] = _VotesAggregate[i][VAULT_ACTION.HelpDevelopment];
            actionVotes[4] = _VotesAggregate[i][
                VAULT_ACTION.WithdrawalToAmbassador
            ];

            uint256 highestVote = max(
                actionVotes[4],
                max(
                    max(actionVotes[0], actionVotes[1]),
                    max(actionVotes[2], actionVotes[3])
                )
            );

            if (highestVote == actionVotes[0]) {
                emit VoteResult(i, VAULT_ACTION.HODL);
            } else if (highestVote == actionVotes[1]) {
                uint256 amountToDistribute = _wallet[_vaultsAddress[i]];
                _wallet[_vaultsAddress[i]] = 0;
                DistributeOverMembers(amountToDistribute);
                emit VoteResult(i, VAULT_ACTION.DistributeOverMembers);
            } else if (highestVote == actionVotes[2]) {
                uint256 amountToDistribute = _wallet[_vaultsAddress[i]];
                _wallet[_vaultsAddress[i]] = 0;
                DistributeOverElders(amountToDistribute);
                emit VoteResult(i, VAULT_ACTION.DistributeOverElders);
            } else if (highestVote == actionVotes[3]) {
                _wallet[_vaultsAddress[VAULT_DEVELOPMENT]] =
                    _wallet[_vaultsAddress[VAULT_DEVELOPMENT]] +
                    _wallet[_vaultsAddress[i]];
                _wallet[_vaultsAddress[i]] = 0;
                emit VoteResult(i, VAULT_ACTION.HelpDevelopment);
            } else if (highestVote == actionVotes[4]) {
                if (_ambassador != address(0)) {
                    uint256 amountToWithdrawal = _wallet[_vaultsAddress[i]];
                    _wallet[_vaultsAddress[i]] = 0;
                    _wallet[_ambassador] =
                        _wallet[_ambassador] +
                        amountToWithdrawal;
                    emit VoteResult(i, VAULT_ACTION.WithdrawalToAmbassador);
                }
            }

            _wallet[_founderAddress] =
                _wallet[_founderAddress] +
                _wallet[_vaultsAddress[VAULT_DEVELOPMENT]];
            _wallet[_vaultsAddress[VAULT_DEVELOPMENT]] = 0;
        }

        _lastElectionDate = block.timestamp;
    }

    function max(uint256 a, uint256 b) public pure returns (uint256) {
        return a >= b ? a : b;
    }

    function DistributeOverMembers(uint256 amount) private {
        uint256 eachShare = amount / _mintedDays.length;
        for (uint256 i = 0; i < _mintedDays.length; i++) {
            _wallet[_holders[_mintedDays[i]]] =
                _wallet[_holders[_mintedDays[i]]] +
                eachShare;
        }
    }

    function DistributeOverElders(uint256 amount) private {
        uint256 eachShare = amount / _eldersAddress.length;
        for (uint256 i = 0; i < _eldersAddress.length; i++) {
            _wallet[_eldersAddress[i]] = _wallet[_eldersAddress[i]] + eachShare;
        }
    }

    function Withdrawal() public {
        require(_wallet[msg.sender] >= MIN_WITHDRAWAL, "e15");
        uint256 amoutToTransfer = _wallet[msg.sender];
        _wallet[msg.sender] = 0;
        emit WithdrawalEvent(msg.sender, amoutToTransfer);
        payable(msg.sender).transfer(amoutToTransfer);
    }

    function SelectPeriodicWinner() public whenNotPaused {
        require(
            BokkyPooBahsDateTimeLibrary.diffDays(
                _lastAirdropPeriodWinnerSelectDate,
                block.timestamp
            ) >= _airdropPeriodInDays,
            "e16"
        );
        require(_periodicAirdropRegisters.length > 1, "e17");
        _lastAirdropPeriodWinnerSelectDate = block.timestamp;
        requestId = requestRandomness(_keyHash, _chainlinkFee);
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
        internal
        override
    {
        require(requestId == _requestId, "e18");
        require(_randomness > 0, "e19");

        uint256 indexOfWinner = _randomness % _periodicAirdropRegisters.length;
        _airdrop[_periodicAirdropRegisters[indexOfWinner]] =
            _airdrop[_periodicAirdropRegisters[indexOfWinner]] +
            1;
        _lastLotteryWinner = _periodicAirdropRegisters[indexOfWinner];
        emit PeriodicAirdropWinnerSelectedEvent(
            _periodicAirdropRegisters[indexOfWinner],
            _randomness
        );
        _periodicAirdropRegisters = new address[](0);
    }

    function MemorizedDays()
        public
        view
        returns (uint256[] memory, address[] memory)
    {
        uint256[] memory day = new uint256[](_mintedDays.length);
        address[] memory holder = new address[](_mintedDays.length);
        for (uint256 i = 0; i < _mintedDays.length; i++) {
            day[i] = _mintedDays[i];
            holder[i] = _holders[_mintedDays[i]];
        }

        return (day, holder);
    }

    function AirdropRegisters() public view returns (address[] memory) {
        address[] memory registers = new address[](
            _periodicAirdropRegisters.length
        );
        for (uint256 i = 0; i < _periodicAirdropRegisters.length; i++) {
            registers[i] = _periodicAirdropRegisters[i];
        }

        return (registers);
    }

    function RegisterForPeriodiclyAirdrop() public whenNotPaused {
        require(!_invitePeriod, "e20");
        bool isPermitted = true;
        for (uint256 i = 0; i < _periodicAirdropRegisters.length; i++) {
            if (_periodicAirdropRegisters[i] == msg.sender) {
                isPermitted = false;
            }
        }
        require(isPermitted, "e21");
        _periodicAirdropRegisters.push(msg.sender);
    }

    function GetHolderOfTheDay(
        uint256 year,
        uint256 month,
        uint256 day
    ) public view returns (address) {
        uint256 _dayNumber = BokkyPooBahsDateTimeLibrary.timestampFromDate(
            year,
            month,
            day
        );
        return _holders[_dayNumber];
    }

    function GetPeriodicAirdropRegistersLength() public view returns (uint256) {
        return _periodicAirdropRegisters.length;
    }

    function GetMintedDaysLength() public view returns (uint256) {
        return _mintedDays.length;
    }

    function Customize(
        uint256 year,
        uint256 month,
        uint256 day,
        string memory memo,
        string memory imageMemo,
        string memory aliass,
        string memory twitterAccount
    ) public {
        uint256 _dayNumber = BokkyPooBahsDateTimeLibrary.timestampFromDate(
            year,
            month,
            day
        );
        require(bytes(memo).length <= 255, "e22");
        require(_holders[_dayNumber] != address(0), "e23");
        require(_holders[_dayNumber] == msg.sender, "e24");
        if (!strings.compareStrings(memo, " ")) {
            _memo[_dayNumber] = memo;
            _likes[_dayNumber] = 0;
        }
        if (!strings.compareStrings(aliass, " ")) {
            _alias[msg.sender] = aliass;
        }
        if (!strings.compareStrings(twitterAccount, " ")) {
            _twitterAccount[_dayNumber] = twitterAccount;
        }
        if (!strings.compareStrings(imageMemo, " ")) {
            require(
                strings.startsWith(
                    strings.toSlice(imageMemo),
                    strings.toSlice(_UrlStartWith)
                ),
                "e25"
            );

            _imageMemo[_dayNumber] = imageMemo;
            _likes[_dayNumber] = 0;
        }
        emit CustomizeEvent(year, month, day);
    }

    function GetIdByDate(
        uint256 year,
        uint256 month,
        uint256 day
    ) public pure returns (uint256) {
        return BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, day);
    }

    //Overrides
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
        require(id >= _startDate, "e26");
        _safeTransferFrom(from, to, id, amount, data);
        _holders[id] = to;
        if (_elders[id]) {
            _eldersAddress[_eldersIndex[id]] = to;
        }
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: transfer caller is not owner nor approved"
        );
        require(false, "e27");
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    //End of Overrides

    //Administration Parts
    function SetAddress(address addrs, uint256 wallet) public onlyOwner {
        if (wallet == 0) {
            address oldAddress = _founderAddress;
            _founderAddress = addrs;
            _wallet[_founderAddress] = _wallet[oldAddress];
            _wallet[oldAddress] = 0;
        } else {
            address oldAddress = _metadataForgerAddress;
            _metadataForgerAddress = addrs;
            _wallet[_metadataForgerAddress] = _wallet[oldAddress];
            _wallet[oldAddress] = 0;
        }
    }

    function PauseContract() public onlyOwner {
        if (paused()) {
            _unpause();
        } else {
            _pause();
        }
    }

    function UpdateConfig(uint256 fee, string memory url)
        public
        onlyOwner
        whenNotPaused
    {
        _chainlinkFee = fee;
        _UrlStartWith = url;
    }

    function SendAirdrop(address targetAirdrop) public onlyElectoral {
        if (!_invitePeriod) {
            require(
                BokkyPooBahsDateTimeLibrary.diffDays(
                    _lastElectoralAirdropDate,
                    block.timestamp
                ) >= _electoralAirdropPeriodInDays,
                "e29"
            );
        }

        require(_airdrop[targetAirdrop] == 0, "e30");
        _lastElectoralAirdropDate = block.timestamp;
        _airdrop[targetAirdrop] = 1;
    }

    function UpdateMintPrice(uint256 newPrice, uint256 newPriceStep)
        public
        onlyElectoral
    {
        newPriceStep = newPriceStep * (10**18);
        newPrice = newPrice * (10**18);
        require(newPriceStep >= 0, "e31");
        require(newPrice >= _initialPrice, "e32");
        _mintPrice = newPrice;
        _mintPriceStep = newPriceStep;
    }

    fallback() external payable {
        _wallet[_vaultsAddress[VAULT_V3]] =
            _wallet[_vaultsAddress[VAULT_V3]] +
            msg.value;
    }

    //End of Administration Parts
}
