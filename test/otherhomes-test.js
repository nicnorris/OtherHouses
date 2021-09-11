const { expect } = require("chai");
const { ethers } = require("hardhat");
const BASE_URI =
  "https://ipfs.io/ipfs//QmaxKQdJUXMVQNVyR4Rj3BJsgqf1CPfHfPqcKAk4speBt4/";
const TEST_WALLET = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"; //1st hardhat wallet

describe("OtherHomes", function () {
  it("Should mint a new token", async function () {
    const OtherHomes = await ethers.getContractFactory("OtherHomes");
    const otherhomes = await OtherHomes.deploy(BASE_URI);
    await otherhomes.deployed();
    await otherhomes.mint(TEST_WALLET, 1);
    expect(await otherhomes.ownerOf(1)).to.equal(TEST_WALLET);
  });
  it("Should return a valid token URI", async function () {
    const OtherHomes = await ethers.getContractFactory("OtherHomes");
    const otherhomes = await OtherHomes.deploy(BASE_URI);
    await otherhomes.deployed(BASE_URI);
    await otherhomes.mint(TEST_WALLET, 1);
    expect(await otherhomes.ownerOf(1)).to.equal(TEST_WALLET);
    expect(await otherhomes.tokenURI(1)).to.equal(`${BASE_URI}1.json`);
  });
});
