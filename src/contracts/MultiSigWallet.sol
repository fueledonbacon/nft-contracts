// SPDX-License-Identifier: MIT
// MultiSigWallet v0.1

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MultiSigWallet is Ownable {
    using SafeERC20 for IERC20;

    address[] public _signers;

    mapping(address => bool) public _isSigner;
    mapping(address => bool) public _signed;

    function appendSigner(address[] memory addresses_) public onlyOwner {
        for (uint256 i = 0; i < addresses_.length; i++) {
            _signers.push(addresses_[i]);
            _isSigner[addresses_[i]] = true;
        }
    }

    function removeSigner(address removeAddr_) public onlyOwner {
        bool isRemoved = false;
        for (uint256 i = 0; i < _signers.length; i++) {
            if (removeAddr_ == _signers[i]) {
                _signers[i] = _signers[_signers.length - 1];
                _isSigner[removeAddr_] = false;
                isRemoved = true;
                break;
            }
        }
        if (isRemoved) {
            _signers.pop();
        }
    }

    function isSignApproved() public view returns (bool) {
        bool isApproved = true;
        for (uint256 i = 0; i < _signers.length; i++) {
            if (!_signed[_signers[i]]) {
                isApproved = false;
                break;
            }
        }
        return isApproved;
    }

    function Sign() public {
        require(_isSigner[msg.sender], "MultiSigWallet: not signer");
        require(!_signed[msg.sender], "MultiSigWallet: already signed user");
        _signed[msg.sender] = true;
    }

    function WithdrawToken(
        address token_,
        address to_,
        uint256 amount_
    ) public onlyOwner {
        require(isSignApproved(), "MultiSigWallet: not signed all");
        IERC20(token_).safeTransfer(to_, amount_);
    }

    function WithdrawCurrency(address payable to_, uint256 amount_)
        public
        onlyOwner
    {
        require(isSignApproved(), "MultiSigWallet: not signed all");
        to_.transfer(amount_);
    }
}
