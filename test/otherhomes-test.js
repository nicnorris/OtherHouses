const { expect } = require("chai");
const { ethers } = require("hardhat");
const BASE_URI = "ipfs://QmaxKQdJUXMVQNVyR4Rj3BJsgqf1CPfHfPqcKAk4speBt4/";
const TEST_WALLET = "0x92bC0dA159D495d3Ca7081544841EC6BD415eB9E";

describe("OtherHomes", function () {
  it("Should mint a new token", async function () {
    const OtherHomes = await ethers.getContractFactory("OtherHomes");
    const otherhomes = await OtherHomes.deploy(BASE_URI);
    await otherhomes.deployed();
    await otherhomes.mintTo(TEST_WALLET);
    expect(await otherhomes.ownerOf(1)).to.equal(TEST_WALLET);
  });
  it("Should return a valid token URI", async function () {
    const OtherHomes = await ethers.getContractFactory("OtherHomes");
    const otherhomes = await OtherHomes.deploy(BASE_URI);
    await otherhomes.deployed(BASE_URI);
    await otherhomes.mintTo(TEST_WALLET);
    expect(await otherhomes.ownerOf(1)).to.equal(TEST_WALLET);
    expect(await otherhomes.tokenURI(1)).to.equal(`${BASE_URI}1`);
  });
});
