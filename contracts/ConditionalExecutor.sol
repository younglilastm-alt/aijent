// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPriceOracle {
    function getLatestPrice() external view returns (uint);
}

contract ConditionalExecutor {
    IPriceOracle public priceOracle;
    address public owner;
    uint public targetPrice;
    uint public executionPrice;

    event ConditionalSell(uint executionPrice);

    constructor(address _priceOracle, uint _targetPrice) {
        priceOracle = IPriceOracle(_priceOracle);
        owner = msg.sender;
        targetPrice = _targetPrice;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function setTargetPrice(uint _targetPrice) external onlyOwner {
        targetPrice = _targetPrice;
    }

    function executeConditionalSell() external onlyOwner {
        uint currentPrice = priceOracle.getLatestPrice();
        require(currentPrice >= targetPrice, "Current price is below target");

        executionPrice = currentPrice;
        emit ConditionalSell(executionPrice);
        // Logic for selling the token or executing a trade would go here
    }
}