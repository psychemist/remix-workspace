// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Crowdfunding {

    event CampaignCreated(address indexed creator, uint campaignId);
    event DonationReceived(uint campaignId, address indexed donor, uint amount);
    event CampaignEnded(uint campaignId, address beneficiary, bool goalMet);

    // Packed struct for storing crowdfunding campaigns
    struct Campaign {
        string title; //name of campaign
        string description; // brief description of campaign
        address benefactor; // address of person or organization that created campaign
        address payable beneficiary; // address of person or organization to receive funds
        uint goal; // fundraising goal (in wei)
        uint amountRaised; // total amount of funds raised so far (in wei)
        uint32 deadline; // Unix timestamp when campaign ends (in seconds)
        bool ended; // campaign active/inactive boolean checker
    }

    Campaign[] public campaigns;
    address public owner;

    // Store balance of every beneficiary in mapping type
    mapping(address => uint) balances;

    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict functions to contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action.");
        _;
    }

    // Create crowdfunding campaign
    function createCampaign(string memory _title, string memory _description, 
                            address payable _beneficiary, uint _goal, uint32 _duration) public {
        // Verify that campaign goal and duration are greater than zero
        require(_goal > 0);
        require(_duration > 0);

        // Calculate deadline from _duration parameter
        uint32 deadline = uint32(block.timestamp + _duration);

        // Create new campaign struct and aadd to campaigns array
        campaigns.push(Campaign(_title, _description, msg.sender, _beneficiary, _goal, 0, deadline, false));

        // Trigger campaign creation event
        emit CampaignCreated(msg.sender, campaigns.length - 1);
    }

    // Donate to crowdfunding campaign
    function donateToCampaign(uint _campaignId) public payable {
        Campaign storage campaign = campaigns[_campaignId];

        // Ensure that campaign is still open to donations
        require(campaign.deadline >= block.timestamp, "Crowdfunding deadline has passed!");

        // Update campaign balance
        require(msg.value > 0, "Donation must be a real value!");
        campaign.amountRaised += msg.value;
        balances[campaign.beneficiary] = campaign.amountRaised;

        // Trigger campaign donation event
        emit DonationReceived(_campaignId, msg.sender, msg.value);
    }

    // Called internally to end campaign
    function _endCampaign(uint _campaignId) internal {
        Campaign storage campaign = campaigns[_campaignId];

        // Verify crowdfunding campaign is not ended
        require(!campaign.ended, "Campaign is not over!");

        // Transfer funds to beneficiary
        if (campaign.amountRaised > 0) {
            (bool sent, bytes memory data) = campaign.beneficiary.call{value: msg.value}("");
            require(sent, "Failed to send funds!");
        }

        // End campaign
        campaign.ended = true;
    }

    // End crowdfunding cmpaign
    function endCampaign(uint _campaignId) public {
        Campaign storage campaign = campaigns[_campaignId];

        // Verify only campaign creator or contract owner can end the crowdfund
        require((msg.sender == campaign.benefactor || msg.sender == owner), "Only campaign owners can end the campaign");

        // Ensure campaign deadline has passed
        require(block.timestamp >= campaign.deadline, "Crowdfunding is still active!");

        // End campaign
        _endCampaign(_campaignId);

        // Trigger campaign closure event
        emit CampaignEnded(_campaignId, campaign.beneficiary, campaign.amountRaised >= campaign.goal);
    }

    // Withdraw leftover funds (only owner)
    function withdrawLeftoverFunds() public onlyOwner {
        // Store valid contract balance in storage variable
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw.");

        // Transfer left over funds to owner
        (bool sent, bytes memory data) = payable(owner).call{value: balance}("");
        require(sent, "Failed to transfer funds!");
    }

    // Fallback function to receive Ether
    receive() external payable {}
}