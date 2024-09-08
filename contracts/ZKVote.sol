// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract AfricanElectoralSystemWithDiaspora is ReentrancyGuard, AccessControl {
    bytes32 public constant ELECTION_OFFICIAL = keccak256("ELECTION_OFFICIAL");
    bytes32 public constant DIASPORA_OFFICIAL = keccak256("DIASPORA_OFFICIAL");

    enum VoterType {
        Resident,
        Diaspora
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        bytes32 voteHash;
        VoterType voterType;
    }

    struct Candidate {
        string name;
        uint256 id;
        uint256 residentVotes;
        uint256 diasporaVotes;
    }

    mapping(address => Voter) private voters;
    Candidate[] public candidates;

    uint256 public votingStart;
    uint256 public votingEnd;
    uint256 public totalResidentVoters;
    uint256 public totalDiasporaVoters;
    bool public resultsReleased;

    event VoterRegistered(address indexed voter, VoterType voterType);
    event VoteCast(address indexed voter, VoterType voterType);
    event CandidateAdded(uint256 indexed candidateId, string name);
    event VotingPeriodSet(uint256 start, uint256 end);
    event ResultsReleased();

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ELECTION_OFFICIAL, msg.sender);
        _grantRole(DIASPORA_OFFICIAL, msg.sender);
    }

    function registerVoter(address _voter, VoterType _voterType) external {
        require(
            (hasRole(ELECTION_OFFICIAL, msg.sender) &&
                _voterType == VoterType.Resident) ||
                (hasRole(DIASPORA_OFFICIAL, msg.sender) &&
                    _voterType == VoterType.Diaspora),
            "Unauthorized to register this voter type"
        );
        require(!voters[_voter].isRegistered, "Voter already registered");

        voters[_voter].isRegistered = true;
        voters[_voter].voterType = _voterType;

        if (_voterType == VoterType.Resident) {
            totalResidentVoters++;
        } else {
            totalDiasporaVoters++;
        }

        emit VoterRegistered(_voter, _voterType);
    }

    function addCandidate(
        string memory _name
    ) external onlyRole(ELECTION_OFFICIAL) {
        uint256 candidateId = candidates.length;
        candidates.push(
            Candidate({
                id: candidateId,
                name: _name,
                residentVotes: 0,
                diasporaVotes: 0
            })
        );
        emit CandidateAdded(candidateId, _name);
    }

    function setVotingPeriod(
        uint256 _start,
        uint256 _end
    ) external onlyRole(ELECTION_OFFICIAL) {
        require(_start < _end, "Invalid voting period");
        votingStart = _start;
        votingEnd = _end;
        emit VotingPeriodSet(_start, _end);
    }

    function castVote(bytes32 _voteHash) external nonReentrant {
        require(
            block.timestamp >= votingStart && block.timestamp <= votingEnd,
            "Voting is not active"
        );
        require(voters[msg.sender].isRegistered, "Not registered to vote");
        require(!voters[msg.sender].hasVoted, "Already voted");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].voteHash = _voteHash;

        emit VoteCast(msg.sender, voters[msg.sender].voterType);
    }

    function getVoteHash(uint256 _candidateId, bytes32 _secret) external pure returns(bytes32) {
        bytes32 voteHash = keccak256(abi.encodePacked(_candidateId, _secret));
        return voteHash;
    }

    function verifyVote(
        address _voter,
        uint256 _candidateId,
        bytes32 _secret
    ) external view returns (bool) {
        require(voters[_voter].hasVoted, "Voter has not cast a vote");
        bytes32 voteHash = keccak256(abi.encodePacked(_candidateId, _secret));
        return voters[_voter].voteHash == voteHash;
    }

    function tallyVote(
        address _voter,
        uint256 _candidateId
    ) external onlyRole(ELECTION_OFFICIAL) {
        require(voters[_voter].hasVoted, "Voter has not cast a vote");
        require(!resultsReleased, "Results already released");

        if (voters[_voter].voterType == VoterType.Resident) {
            candidates[_candidateId].residentVotes++;
        } else {
            candidates[_candidateId].diasporaVotes++;
        }

        // Clear the vote hash to prevent double counting
        voters[_voter].voteHash = bytes32(0);
    }

    function releaseResults() external onlyRole(ELECTION_OFFICIAL) {
        require(block.timestamp > votingEnd, "Voting has not ended");
        require(!resultsReleased, "Results already released");
        resultsReleased = true;
        emit ResultsReleased();
    }

    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }

    function getVoterCounts()
        external
        view
        returns (uint256 resident, uint256 diaspora)
    {
        return (totalResidentVoters, totalDiasporaVoters);
    }

    // Additional functions for result verification and analysis would be needed
}
