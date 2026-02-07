// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RuleEngine {
    struct WithdrawalRule {
        uint256 minAmount;
        uint256 maxAmount;
        bool isEnabled;
    }

    struct ScheduledWithdrawal {
        address user;
        uint256 amount;
        uint256 scheduledTime;
    }

    mapping(address => WithdrawalRule) public withdrawalRules;
    ScheduledWithdrawal[] public scheduledWithdrawals;

    event WithdrawalScheduled(address indexed user, uint256 amount, uint256 scheduledTime);
    
    function setWithdrawalRule(uint256 minAmount, uint256 maxAmount, bool isEnabled) external {
        withdrawalRules[msg.sender] = WithdrawalRule(minAmount, maxAmount, isEnabled);
    }

    function scheduleWithdrawal(uint256 amount, uint256 time) external {
        require(amount >= withdrawalRules[msg.sender].minAmount, "Amount below minimum");
        require(amount <= withdrawalRules[msg.sender].maxAmount, "Amount above maximum");
        require(withdrawalRules[msg.sender].isEnabled, "Withdrawal rules disabled");

        scheduledWithdrawals.push(ScheduledWithdrawal(msg.sender, amount, time));
        emit WithdrawalScheduled(msg.sender, amount, time);
    }

    function executeScheduledWithdrawals() external {
        for(uint i = 0; i < scheduledWithdrawals.length; i++) {
            if(block.timestamp >= scheduledWithdrawals[i].scheduledTime) {
                // Logic to transfer amount to user
                // Remove the scheduled withdrawal
            }
        }
    }

    // Additional functions can be added here for conditional sell logic
}