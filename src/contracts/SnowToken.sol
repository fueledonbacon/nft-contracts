// SPDX-License-Identifier: MIT
// SnowToken v0.1
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SnowToken is
    ERC20,
    ERC20Burnable,
    ERC20Permit,
    ERC20Votes,
    Pausable,
    Ownable
{
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 public _cap;

    uint256[] public _tokenomics;

    address[] public _mintWallets;

    constructor(
        string memory name,
        string memory symbol,
        uint256 cap_
    ) ERC20(name, symbol) ERC20Permit(name) {
        _cap = cap_;
    }

    function _updateTokenomics(
        address[] memory mintWallets_,
        uint256[] memory tokenomics_
    ) private {
        delete _mintWallets;
        delete _tokenomics;
        require(
            mintWallets_.length == tokenomics_.length,
            "SnowToken: mismatch tokenomics size"
        );
        uint256 totalCap_ = 0;
        for (uint256 i = 0; i < mintWallets_.length; i++) {
            if (mintWallets_[i] == address(0x0)) continue;
            _mintWallets.push(mintWallets_[i]);
            _tokenomics.push(tokenomics_[i]);
            totalCap_ = totalCap_.add(tokenomics_[i]);
        }
        require(totalCap_ == _cap, "SnowToken: mismatch total supply");
    }

    function updateTokenomics(
        address[] memory mintWallets_,
        uint256[] memory tokenomics_
    ) external onlyOwner {
        _updateTokenomics(mintWallets_, tokenomics_);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function mintAll() external onlyOwner {
        require(_tokenomics.length > 0, "SnowToken: tokenomics not configured");
        for (uint256 i = 0; i < _tokenomics.length; i++) {
            _mint(_mintWallets[i], _tokenomics[i]);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        require(
            totalSupply().add(amount) <= _cap,
            "SnowToken: already minted all"
        );
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }

    function emergencyWithdrawToken(address token_, address to_)
        external
        onlyOwner
    {
        IERC20(token_).safeTransfer(
            to_,
            IERC20(token_).balanceOf(address(this))
        );
    }

    function emergencyWithdrawCurrency(address to_) external onlyOwner {
        payable(to_).transfer(address(this).balance);
    }
}
