// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PremiumManager {
    struct Subscription {
        uint256 startDate;
        uint256 endDate;
        bool active;
    }
    
    mapping(address => Subscription) private subscriptions;
    mapping(address => uint256) private balances;
    
    uint256 public premiumFee;

    event SubscriptionCreated(address indexed user, uint256 startDate, uint256 endDate);
    event SubscriptionRenewed(address indexed user, uint256 startDate, uint256 endDate);

    constructor(uint256 _premiumFee) {
        premiumFee = _premiumFee;
    }
    
    modifier onlyActiveSubscription() {
        require(subscriptions[msg.sender].active, "No active subscription.");
        _;
    }
    
    function subscribe() external payable {
        require(msg.value == premiumFee, "Incorrect premium fee.");
        require(!subscriptions[msg.sender].active, "Already subscribed.");
        
        uint256 startDate = block.timestamp;
        uint256 endDate = startDate + 30 days; // 1 month subscription
        subscriptions[msg.sender] = Subscription(startDate, endDate, true);
        balances[address(this)] += msg.value;

        emit SubscriptionCreated(msg.sender, startDate, endDate);
    }
    
    function renewSubscription() external payable onlyActiveSubscription {
        require(msg.value == premiumFee, "Incorrect premium fee.");
        
        uint256 startDate = block.timestamp;
        uint256 endDate = startDate + 30 days; // 1 month extension
        subscriptions[msg.sender].startDate = startDate;
        subscriptions[msg.sender].endDate = endDate;

        balances[address(this)] += msg.value;

        emit SubscriptionRenewed(msg.sender, startDate, endDate);
    }
    
    function isSubscribed() external view returns (bool) {
        return subscriptions[msg.sender].active && block.timestamp <= subscriptions[msg.sender].endDate;
    }
}