// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract SimpleStorage {
    // bool hasFavoriteNum = true;
    // string favoriteNumInText = "88";
    // address myAddress = 0xf3300Fc627840Ba99835A6FEc622e83eB56768C2;
    // bytes32 favBytes32 = "88";

    uint256 favoriteNum; //0

    // uint256[] listFavoriteNumbers;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    // Person public myFriend = Person(7, "Pat");
    // Person public myFriend = Person({favoriteNumber: 7, name: "Pat"});

    // dynamic array (can grow or shrink in size), static arrays have a set size.
    Person[] public listOfPeople;

    function store(uint256 _favoriteNum) public virtual {
        favoriteNum = _favoriteNum;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNum;
    }

    //memory variable = temporary variable that CAN be modified
    //calldata variable = temporary variable that CANNOT be modified
    //storage variable = variable that is perminent to the contract
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    mapping(string => uint256) public nameToFavoriteNumber;
}

contract SimpleStorage2 {}
