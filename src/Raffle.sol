// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

/**
 * @title A sample Raffle contract
 * @author Andrea De Blasio
 * @notice This contract is a sample Raffle contract
 * @dev Implement Chainlink VRF to generate random numbers
 */
contract Raffle {
    /*       ERRORS       */
    error Raffle__SendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent");          // Version 1: Expensive way to print an error message
        // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle());        // Version 3 - from 0.8.26: Cheaper way to print an error message, readable
        // Version 2: Cheaper way to print an error message, not really readable but it's ok for 0.8.19
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
    }

    function pickWinner() public {}

    /*       GETTER FUNCTIONS       */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
