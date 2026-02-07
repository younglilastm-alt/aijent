// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
 import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract AITimeVault is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    // Events for logging 
    event PremiumPaid(address indexed user, uint256 amount);
    event Deposit(address indexed user, uint256 amount, uint256 indexed timestamp);
    event Withdraw(address indexed user, uint256 amount, uint256 indexed timestamp);
    event ScheduledWithdraw(address indexed user, uint256 amount, uint256 indexed scheduledTime);
    event EmergencyStopped();

    struct User {
        uint256 balance;
        uint256 premiumPaid;
        bool isLocked;
        uint256 lockUntil;
        uint256 withdrawalLimit;
        uint256 scheduledWithdrawTime;
        bool isScheduled;
    }

    mapping(address => User) public users;

    uint256 public totalPremium;
    address payable public premiumBeneficiary;
    bool public emergencyStop = false;

    modifier notLocked() {
        require(!users[msg.sender].isLocked, "Account is locked.");
        _;
    }

    modifier onlyWhenNotEmergency() {
        require(!emergencyStop, "Contract is in emergency mode.");
        _;
    }

    constructor() {
        premiumBeneficiary = payable(0xE358B02A5d75358e8A2fFa00407c1f6d6b817faE);
    }

    function payPremium() external payable onlyWhenNotEmergency {
        require(msg.value > 0, "Premium must be greater than zero.");
        users[msg.sender].premiumPaid = users[msg.sender].premiumPaid.add(msg.value);
        totalPremium = totalPremium.add(msg.value);
        premiumBeneficiary.transfer(msg.value);
        emit PremiumPaid(msg.sender, msg.value);
    }

    function deposit() external payable onlyWhenNotEmergency notLocked {
        require(msg.value > 0, "Deposit must be greater than zero.");
        users[msg.sender].balance = users[msg.sender].balance.add(msg.value);
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(uint256 amount) external nonReentrant onlyWhenNotEmergency notLocked {
        require(users[msg.sender].balance >= amount, "Insufficient balance.");
        require(amount <= users[msg.sender].withdrawalLimit, "Exceeds withdrawal limit.");
        users[msg.sender].balance = users[msg.sender].balance.sub(amount);
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount, block.timestamp);
    }

    function scheduleWithdraw(uint256 amount, uint256 time) external onlyWhenNotEmergency notLocked {
        require(users[msg.sender].balance >= amount, "Insufficient balance.");
        require(block.timestamp + time > block.timestamp, "Scheduled time must be in the future.");
        users[msg.sender].scheduledWithdrawTime = block.timestamp + time;
        users[msg.sender].isScheduled = true;
        emit ScheduledWithdraw(msg.sender, amount, users[msg.sender].scheduledWithdrawTime);
    }

    function executeScheduledWithdraw() external nonReentrant onlyWhenNotEmergency {
        require(users[msg.sender].isScheduled, "No scheduled withdrawal found.");
        require(block.timestamp >= users[msg.sender].scheduledWithdrawTime, "Scheduled time not reached.");
        uint256 amount = users[msg.sender].balance;
        users[msg.sender].balance = 0;
        payable(msg.sender).transfer(amount);
        users[msg.sender].isScheduled = false;
        emit Withdraw(msg.sender, amount, block.timestamp);
    }

    function emergencyStopContract() external onlyOwner {
        emergencyStop = true;
        emit EmergencyStopped();
    }

    function resumeContract() external onlyOwner {
        emergencyStop = false;
    }

    function setWithdrawalLimit(uint256 limit) external onlyOwner {
        users[msg.sender].withdrawalLimit = limit;
    }

    function lockAccount(uint256 duration) external onlyWhenNotEmergency {
        users[msg.sender].isLocked = true;
        users[msg.sender].lockUntil = block.timestamp.add(duration);
    }

    function unlockAccount() external onlyWhenNotEmergency {
        require(block.timestamp >= users[msg.sender].lockUntil, "Account is still locked.");
        users[msg.sender].isLocked = false;
    }

    function balanceOf(address user) external view returns (uint256) {
        return users[user].balance;
    }

    function premiumPaidBy(address user) external view returns (uint256) {
        return users[user].premiumPaid;
    }
}