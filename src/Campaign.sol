// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Campaign {
    address public immutable creator;
    uint256 public immutable goal;
    uint256 public immutable deadline;
    uint256 public pledged;
    bool public withdrawn;

    mapping(address => uint256) public contributions;

    event Pledged(address indexed backer, uint256 amount);
    event GoalReached();
    event FundsWithdrawn(address indexed creator, uint256 amount);
    event RefundClaimed(address indexed backer, uint256 amount);

    constructor(uint256 _goal, uint256 _deadline) {
        require(_deadline > block.timestamp, "deadline in past");
        creator = msg.sender;
        goal = _goal;
        deadline = _deadline;
    }

    function pledge() external payable {
        require(block.timestamp <= deadline, "ended");
        require(msg.value > 0, "zero amount");
        pledged += msg.value;
        contributions[msg.sender] += msg.value;
        emit Pledged(msg.sender, msg.value);
        if (pledged >= goal) {
            emit GoalReached();
        }
    }

    function withdraw() external {
        require(msg.sender == creator, "not creator");
        require(block.timestamp > deadline, "not ended");
        require(pledged >= goal, "goal not met");
        require(!withdrawn, "already withdrawn");
        withdrawn = true;
        emit FundsWithdrawn(creator, pledged);
        payable(creator).transfer(pledged);
    }

    function refund() external {
        require(block.timestamp > deadline, "not ended");
        require(pledged < goal, "goal met");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "nothing to refund");
        contributions[msg.sender] = 0;
        emit RefundClaimed(msg.sender, amount);
        payable(msg.sender).transfer(amount);
    }
}
