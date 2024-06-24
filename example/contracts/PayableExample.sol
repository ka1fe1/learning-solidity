// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";


contract PayableExample is Ownable {
    event Donation(address indexed addr, uint256 amount);
    event Withdrawal(address indexed addr, uint256 amount);
    
    mapping(address => uint256) public contributors;
    
    constructor() Ownable(msg.sender) {
    }

    function donate() payable public {
        require(msg.value > 0, "donate amount must gt 0");

        uint256 contributorAmt = contributors[msg.sender];

        bool success;
        uint256 newAmt;
        (success, newAmt) = Math.tryAdd(contributorAmt, msg.value);

        require(success == true, "add method overflowed");

        contributors[msg.sender] = newAmt;

        emit Donation(msg.sender, msg.value);
    }


    function withdraw(uint256 amount) onlyOwner public {
        require(amount > 0, "withdraw amount must gt 0");

        require(amount <= address(this).balance, "not enough balance to be withdrawed");

        payable(msg.sender).transfer(amount);

        emit Withdrawal(msg.sender, amount);
    } 

}