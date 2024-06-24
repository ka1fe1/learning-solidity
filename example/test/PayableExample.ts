
import { ethers } from "hardhat";
import { expect } from "chai"
import { PayableExample } from "../typechain-types";

describe("test payable", function () {
    // let signers: ethers.Signer[];
    // let owner: Signer;
    let payableContract: PayableExample;
    let signers: any;
    let owner: any;

    beforeEach(async function name() {
        signers = await ethers.getSigners();
        owner = signers[0];
        payableContract = await deployPayable();
        
    });

    it("test denote", async () => {
        await payableContract.donate({value: ethers.parseEther("1")});        
    });


    const deployPayable = async () => {
        let contractFactory = await ethers.getContractFactory("PayableExample");
        let payableContract = await contractFactory.deploy();

        await payableContract.deployed();

        return payableContract as PayableExample;
    }
})