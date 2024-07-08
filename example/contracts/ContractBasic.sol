// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract OtherContract is Ownable {
    uint256 public x;

    // define err
    error notEnoughBalanceToWithdraw(uint256 currentBalance, uint256 withdrawAmount);

    // define events
    event Received(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed withdrawer, uint256 amount);
 

    constructor(uint256 p1) Ownable(msg.sender) {
        x = p1;
    }

    function setValue(uint p1) public payable {
        x = p1;
        if (msg.value > 0) {
            emit Received(msg.sender, msg.value);
        }
    }

    function getValue() public view returns(uint256) {
        return x;
    }

    function withdraw(uint256 amount) onlyOwner public {
        require(amount > 0, "withdraw amount must gt 0");
        if (address(this).balance < amount) {
            revert notEnoughBalanceToWithdraw(address(this).balance, amount);
        }

        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}

contract Caller {

    // 传入合约地址调用合约
    function setValueAndTransferETH(address payable contractAddr, uint256 x) public payable {
        OtherContract(contractAddr).setValue{value: msg.value}(x);
    }

    // 实例化合约变量调用合约
    function getValue(address payable contractAddr) public view returns(uint256) {
        OtherContract oa = OtherContract(contractAddr);
        uint256 x = oa.getValue();
        return x;
    }

    // 传入合约变量调用合约
    function getValue2(OtherContract c) public view returns(uint256)  {
        uint256 x = c.getValue();
        return x;
    }
}