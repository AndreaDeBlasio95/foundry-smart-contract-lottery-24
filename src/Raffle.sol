// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

/**
 * @title A sample Raffle contract
 * @author Andrea De Blasio
 * @notice This contract is a sample Raffle contract
 * @dev Implement Chainlink VRF to generate random numbers
 */
contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {}

    function pickWinner() public {}

    /**
     * GETTER FUNCTIONS
     */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
