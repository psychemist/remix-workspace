// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20 {
    address public owner;
    uint256 public constant MAX_SUPPLY = 1e12 * 1e18; // Example: 1 million tokens with 18 decimals

    constructor() ERC20("MyToken", "MTK") {
        owner = msg.sender;
        _mint(address(this), MAX_SUPPLY);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // Additional functions for your contract (e.g., staking, distribution)
    // function transferToContract() external onlyOwner {
    //     uint256 amount = balanceOf(msg.sender);
    //     _transfer(msg.sender, address(this), amount);
    // }

    function getTokens(uint256 _amount) external {
        require(msg.sender != address(0), "Sender cannot be Address Zero!");
        require(_amount > 0, "Cannot transfer 0 tokens!");
        require(IERC20(address(this)).balanceOf(address(this)) >= _amount);

        IERC20(address(this)).transfer(msg.sender, _amount);
    }
}