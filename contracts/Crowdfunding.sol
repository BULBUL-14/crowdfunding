// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public raised;

    mapping(address => uint) public contributions;

    constructor(uint _goalInWei, uint _durationInSeconds) {
        owner = msg.sender;
        goal = _goalInWei;
        deadline = block.timestamp + _durationInSeconds;
    }

    // Contribute to the campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign ended");
        require(msg.value > 0, "Must send ETH");
        contributions[msg.sender] += msg.value;
        raised += msg.value;
    }

    // Withdraw funds if goal is met
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= deadline, "Campaign not ended");
        require(raised >= goal, "Goal not reached");
        payable(owner).transfer(address(this).balance);
    }
