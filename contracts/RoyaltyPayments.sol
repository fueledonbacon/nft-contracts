// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/finance/PaymentSplitter.sol';

contract RoyaltyPayments is PaymentSplitter {
    constructor(address[] memory payees_, uint256[] memory shares_)
        PaymentSplitter(payees_, shares_)
    {}
}
