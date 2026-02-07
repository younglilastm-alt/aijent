// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WithdrawalQuotaManager {
    mapping(address => uint256) private withdrawalLimits;
    mapping(address => uint256) private lastWithdrawalTime;
    uint256 public cooldownPeriod;

    event Withdrawal(address indexed user, uint256 amount);
    event QuotaUpdated(address indexed user, uint256 newQuota);

    constructor(uint256 _cooldownPeriod) {
        cooldownPeriod = _cooldownPeriod;
    }

    function setWithdrawalLimit(address user, uint256 limit) external {
        withdrawalLimits[user] = limit;
        emit QuotaUpdated(user, limit);
    }

    function withdraw(uint256 amount) external {
        require(amount <= withdrawalLimits[msg.sender], "Amount exceeds withdrawal limit.");
        require(block.timestamp >= lastWithdrawalTime[msg.sender] + cooldownPeriod, "Withdrawals are on cooldown.");

        withdrawalLimits[msg.sender] -= amount;
        lastWithdrawalTime[msg.sender] = block.timestamp;
        emit Withdrawal(msg.sender, amount);
    }

    function getCurrentQuota() external view returns (uint256) {
        return withdrawalLimits[msg.sender];
    }
}