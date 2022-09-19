// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Ambassador {
    address public _ambassador;
    //which holder selects which another holder as ambassador
    mapping(uint256 => address) public _ambasaddorVotes;
    //which holder has how much votes
    mapping(address => uint256) public _ambassadorVotesAggregate;
    //who is currently at the top of voting
    address public _nextAmbassador;

    function GetCurrentVote(uint256 holder) public view returns (address) {
        return _ambasaddorVotes[holder];
    }

    function GetCurrentAmbassador() public view returns (address) {
        return _ambassador;
    }

    function Vote(
        address suggestedAmbasaddor,
        uint256 holder,
        uint256 votingPower
    ) external {
        _ambassadorVotesAggregate[_ambasaddorVotes[holder]] =
            _ambassadorVotesAggregate[_ambasaddorVotes[holder]] -
            votingPower;
        _ambassadorVotesAggregate[suggestedAmbasaddor] =
            _ambassadorVotesAggregate[suggestedAmbasaddor] +
            votingPower;
        _ambasaddorVotes[holder] = suggestedAmbasaddor;

        if (
            _ambassadorVotesAggregate[suggestedAmbasaddor] >
            _ambassadorVotesAggregate[_nextAmbassador]
        ) {
            _nextAmbassador = suggestedAmbasaddor;
        }
    }

    function Election(uint256 acceptanceThreshold) external {
        require(
            _ambassadorVotesAggregate[_nextAmbassador] >= acceptanceThreshold,
            "Low participants"
        );

        if (_nextAmbassador != _ambassador) {
            _ambassador = _nextAmbassador;
        }
    }
}
