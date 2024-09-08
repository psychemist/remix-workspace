// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


contract W3CXI is ERC20 {
    address private _owner;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _supply,
        address _account
    ) ERC20(_name, _symbol) {
        _owner = msg.sender;
        _mint(_account, _supply);
    }

    function mintMoreTokens(uint256 amount) external {
        require(msg.sender == _owner, "Only owner can mint more tokens!");
        _mint(_owner, amount);
    }

    // function getTokens(uint256 _amount) external {
    //     require(msg.sender != address(0), "Sender cannot be Address Zero!");
    //     require(_amount > 0, "Cannot deposit 0 tokens!");

    // }
}
