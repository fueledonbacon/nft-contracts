// SPDX-License-Identifier: MIT
// SnowToken v0.1
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

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

    uint256 public cap = 250000000;

    address public lockedMultiSigWallet;
    address public treasuryWallet = 0x1FF0a45474f1588922aF70DE2ee78036193f289e;
    address public polientVault;
    address public LPfarmContract;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        ERC20Permit(name)
    {}

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(
            totalSupply().add(amount) <= cap,
            '$lodge::mint: cannot exceed max supply'
        );
        _mint(to, amount);
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
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }

    function setLockedWalletAddress(address newAddress) external onlyOwner {
        lockedMultiSigWallet = newAddress;
    }

    function setPolientVaultAddress(address newAddress) external onlyOwner {
        polientVault = newAddress;
    }

    function setLPfarmAddress(address newAddress) external onlyOwner {
        LPfarmContract = newAddress;
    }
}
