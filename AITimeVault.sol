// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AITimeVault {
    struct Deposit {
        address depositor;
        uint256 amount;
        uint256 timestamp;
        bool premiumPaid;
    }

    mapping(address => Deposit[]) private deposits;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    modifier enforceRules(uint256 amount) {
        require(amount > 0, "Amount must be greater than zero.");
        require(msg.sender.balance >= amount, "Insufficient balance.");
        _;
    }

    function deposit() public payable enforceRules(msg.value) {
        deposits[msg.sender].push(Deposit({
            depositor: msg.sender,
            amount: msg.value,
            timestamp: block.timestamp,
            premiumPaid: false
        }));
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public enforceRules(amount) {
        uint256 totalDeposited = getTotalDeposited(msg.sender);
        require(totalDeposited >= amount, "Insufficient funds in vault.");
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function getTotalDeposited(address user) public view returns (uint256 total) {
        Deposit[] memory userDeposits = deposits[user];
        for (uint256 i = 0; i < userDeposits.length; i++) {
            total += userDeposits[i].amount;
        }
    }

    function payPremium() public payable enforceRules(msg.value) {
        Deposit[] storage userDeposits = deposits[msg.sender];
        require(userDeposits.length > 0, "No deposits found.");
        userDeposits[userDeposits.length - 1].premiumPaid = true;
    }
}