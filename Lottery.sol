// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address payable public owner;
    uint public minRange;
    uint public maxRange;
    uint public timeLimit;
    mapping(address => uint) private lastExecution;
    mapping(address => uint) private reward;
    event TicketChecked(uint randomNumber, address caller);

    constructor(uint _minRange, uint _maxRange) {
        owner = payable(msg.sender);
        minRange = _minRange;
        maxRange = _maxRange;
        timeLimit = 1 hours;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function changeRange(uint _minRange, uint _maxRange) public onlyOwner {
        minRange = _minRange;
        maxRange = _maxRange;
    }

    function changeTimeLimit(uint _timeLimit) public onlyOwner {
        timeLimit = _timeLimit;
    }

    function checkTicket() public {
        require(
            block.timestamp >= lastExecution[msg.sender] + timeLimit,
            "Can only check ticket once within the time limit"
        );

        uint randomNumber = (uint(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % (maxRange - minRange + 1)) + minRange;
        lastExecution[msg.sender] = block.timestamp;
        reward[msg.sender] = randomNumber;
        emit TicketChecked(randomNumber, msg.sender);
    }

    function getLastExecutionTime(address _address) public view returns (uint) {
        return lastExecution[_address];
    }

    function getLastReward(address _address) public view returns (uint) {
        return reward[_address];
    }
}