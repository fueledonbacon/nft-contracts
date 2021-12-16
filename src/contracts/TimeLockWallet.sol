// SPDX-License-Identifier: MIT
// MultiSigWallet v0.1

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TimeLockWallet is Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    bool _isTimeConfigured = false;
    uint256 _unlockTimestamp = 0;

    constructor(uint256 unlockTimestamp_) {
        require(
            !_isTimeConfigured,
            "TimeLockWallet: unlock time already configured"
        );
        _unlockTimestamp = unlockTimestamp_;
        _isTimeConfigured = true;
    }

    function isUnlocked() public view returns (bool) {
        if (_unlockTimestamp == 0) return false;
        if (block.timestamp > _unlockTimestamp) return true;
        return false;
    }

    function WithdrawToken(
        address token_,
        address to_,
        uint256 amount_
    ) public onlyOwner {
        require(isUnlocked(), "TimeLockWallet: token withdraw locked");
        IERC20(token_).safeTransfer(to_, amount_);
    }

    function WithdrawCurrency(address payable to_, uint256 amount_)
        public
        onlyOwner
    {
        require(isUnlocked(), "TimeLockWallet: currency withdraw locked");
        to_.transfer(amount_);
    }
}
