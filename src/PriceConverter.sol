// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getEthPrice(address _priceFeed) internal view returns (uint256) {
        AggregatorV3Interface ethUsdDatafeed = AggregatorV3Interface(_priceFeed);

        (, int256 price,,,) = ethUsdDatafeed.latestRoundData();
        return uint256(price) * (10 ** (18 - ethUsdDatafeed.decimals()));
    }

    function convertToUsd(uint256 _ethAmount, address _priceFeed) public view returns (uint256) {
        uint256 _ethPrice = getEthPrice(_priceFeed);
        uint256 totalPrice = _ethPrice * _ethAmount;

        return totalPrice / 1e18;
    }

    function version(address _priceFeed) public view returns (uint256) {
        AggregatorV3Interface ethUsdDatafeed = AggregatorV3Interface(_priceFeed);

        return ethUsdDatafeed.version();
    }
}
