// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const initBaseUri =
  "https://ipfs.io/ipfs/QmPoMHJTLAxfJjYEssMiMPb36JYw7gTsE9syCu14j9ZatB/";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const OtherHomes = await hre.ethers.getContractFactory("OtherHomes");
  const otherHomes = await OtherHomes.deploy(initBaseUri);

  await otherHomes.deployed();

  console.log("Other Homes test deployed to:", otherHomes.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
