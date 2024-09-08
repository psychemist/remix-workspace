// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "./W3CXI.sol";

contract SaveERC20 {
    address public owner;
    IERC20 public token;

    mapping(address user => uint256) balances;

    event DepositSuccessful(address indexed sender, uint amount);
    event WithdrawSuccessful(address indexed receiver, uint amount);
    event TransferSuccessful(
        address indexed sender,
        address indexed receiver,
        uint amount
    );

    constructor(address _tokenAddress) {
        owner = msg.sender;
        token = IERC20(_tokenAddress);
    }

    modifier onlyOwner(address sender) {
        require(sender == owner, "Only owner can perform this action!");
        _;
    }

    function depositTokens(uint256 _amount) external {
        require(msg.sender != address(0), "Sender cannot be Address Zero!");
        require(_amount > 0, "Cannot deposit 0 tokens!");

        bool success = token.transferFrom(msg.sender, address(this), _amount);
		require(success, "Token transfer failed");

        balances[msg.sender] += _amount;

        emit DepositSuccessful(msg.sender, _amount);
    }

    function withdrawTokens(uint256 _amount) external {
        require(msg.sender != address(0), "Sender cannot be Address Zero!");
        require(_amount > 0, "Cannot withdraw 0 tokens!");
        require(
            balances[msg.sender] >= _amount,
            "Insufficient funds in savings"
        );

        balances[msg.sender] -= _amount;

        token.transfer(msg.sender, _amount);

        emit WithdrawSuccessful(msg.sender, _amount);
    }

    function transferTokensInternal(address _to, uint256 _amount) external {
		require(msg.sender != address(0), "Sender cannot be Address Zero!");
		require(_to != address(0), "Receiver cannot be Address Zero!");
        require(_amount > 0, "Cannot withdraw 0 tokens!");
		require(balances[msg.sender] >= _amount);

		balances[msg.sender] -= _amount;
		balances[_to] += _amount;

		emit TransferSuccessful(msg.sender, _to, _amount);
	}

    function transferTokensExternal(address _to, uint256 _amount) external {
		require(msg.sender != address(0), "Sender cannot be Address Zero!");
		require(_to != address(0), "Receiver cannot be Address Zero!");
        require(_amount > 0, "Cannot withdraw 0 tokens!");
		require(balances[msg.sender] >= _amount);

		balances[msg.sender] -= _amount;

		token.transfer(_to, _amount);

		emit TransferSuccessful(msg.sender, _to, _amount);
	}

    // function getContractBalance() external onlyOwner returns(uint256 contractBalance_) {
    function getContractBalance() public view onlyOwner(msg.sender)  returns (uint256) {
        // return token.balanceOf(address(this));
        // contractBalance_ = IERC20(tokenAddress).balanceOf(address(this));
        return token.balanceOf(address(this));
    }

    function getUserBalance(
        address _user
    ) external view onlyOwner(msg.sender)  returns (uint256) {
        return balances[_user];
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

	function withdrawFunds() external onlyOwner(msg.sender) {
		token.transfer(owner, getContractBalance());
	}
}
