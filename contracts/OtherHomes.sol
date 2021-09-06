// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
//wraps erc-721 contract
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SmartContract is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseURI;
  //for safe measure .json
  string public baseExtension = ".json";
  uint256 public cost = 0.02 ether;
  uint256 public maxSupply = 10000;
  uint256 public maxMintAmount = 20;
  //ability to pause if something goes wrong
  bool public paused = false;

  constructor(string memory _initBaseURI) ERC721("Other Homes Test", "OHT") {
    setBaseURI(_initBaseURI);
    //mints # to team/ contract owner also for drops etc.
    mint(msg.sender, 20);
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  //takes in 2 perameters 
  function mint(address _to, uint256 _mintAmount) public payable {
      //extract from total supply
    uint256 supply = totalSupply();
    //make sure not paused
    require(!paused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    //checks if enough left
    require(supply + _mintAmount <= maxSupply);

    // if not owner we charge a fee
    if (msg.sender != owner()) {
      require(msg.value >= cost * _mintAmount);
    }

    //initilize at 1
    for (uint256 i = 1; i <= _mintAmount; i++) {
        //underlying minding funciton pass to who mints
        //also where mint goes to what address running a loop
      _safeMint(_to, supply + i);
    }
  }

    //
  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    //make sure i is less than token acocunts
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

    // all erc-721 have for metadata
  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
      //check if token id exists
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );

    // take baseuri from above funciton
    string memory currentBaseURI = _baseURI();
    return
    //if bytes are bigger than 0 will return encodedpacked, if not ""
      bytes(currentBaseURI).length > 0
        ? string(
            //concatenates currentbaseuri, token id, base extention for .json
            //might remove base extention for ipfs
          abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
        )
        : "";
  }

  //only owner

  //sets new cost
  function setCost(uint256 _newCost) public onlyOwner() {
    cost = _newCost;
  }
  
  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
    maxMintAmount = _newmaxMintAmount;
  }
    // if we want to move metadata
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }
    // 
  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
  
  //important- all money in contract will be able to be withdrawn by owner
  function withdraw() public payable onlyOwner {
    require(payable(msg.sender).send(address(this).balance));
  }
}