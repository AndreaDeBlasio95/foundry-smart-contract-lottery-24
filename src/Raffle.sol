// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title A sample Raffle contract
 * @author Andrea De Blasio
 * @notice This contract is a sample Raffle contract
 * @dev Implement Chainlink VRF to generate random numbers
 */
contract Raffle is VRFConsumerBaseV2Plus {
    /*       ERRORS       */
    error Raffle__SendMoreToEnterRaffle();
    error Raffle__TransferFailed();

    /*       EVENTS       */
    // Everytime you work with storage variables you should emit an event
    event RaffleEnterd(address indexed player);

    /*       STATE VARIABLES       */
    uint16 private constant REQUEST_CONFIRMATION = 3;
    uint8 private constant NUM_WORDS = 1;
    uint256 private immutable i_entranceFee;
    // @dev The duration of the lottery in seconds
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent");          // Version 1: Expensive way to print an error message
        // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle());        // Version 3 - from 0.8.26: Cheaper way to print an error message, readable
        // Version 2: Cheaper way to print an error message, not really readable but it's ok for 0.8.19
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));
        // Why working with events?
        // 1. Makes migration easier
        // 2. Makes front-end "indexing" easier
        emit RaffleEnterd(msg.sender);
    }

    function pickWinner() external {
        // check to see if enough time has passed
        if ((block.timestamp - s_lastTimeStamp) > i_interval) {
            revert();
        }
        // Get a random number using VRF2.5
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: i_keyHash,
            subId: i_subscriptionId,
            requestConfirmations: REQUEST_CONFIRMATION,
            callbackGasLimit: i_callbackGasLimit,
            numWords: NUM_WORDS,
            extraArgs: VRFV2PlusClient._argsToBytes(
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
        });

        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal virtual override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        (bool success,) = recentWinner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    /*       GETTER FUNCTIONS       */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
