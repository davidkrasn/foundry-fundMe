// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {SimpleStorage, SimpleStorage2} from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    function sfStorage(
        uint256 _simpleStorageIndex,
        uint256 _newSimpleStorageNumber
    ) public {
        // Always need Address and ABI to interact with another contract

        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _newSimpleStorageNumber
        );
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}
