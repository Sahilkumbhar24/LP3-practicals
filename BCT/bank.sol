// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SimpleBank - deposit, withdraw, check balance
contract SimpleBank {
    address public owner;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    

    mapping(address => uint256) private balances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice deposit ether to your balance
    function deposit() external payable {
        require(msg.value > 0, "Must deposit > 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /// @notice withdraw `amount` wei from your balance
    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");

        emit Withdraw(msg.sender, amount);
    }

    /// @notice check your balance
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }


    /// @notice receive ETH normally
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /// @notice fallback: allow ETH but avoid accidental deposits
    fallback() external payable {
        require(msg.value > 0, "No ETH sent");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
}
