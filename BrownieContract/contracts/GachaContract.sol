// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract Gacha is VRFConsumerBase, Ownable {

    bytes32 internal keyHash;
    uint256 internal fee;

    //Gacha variable

    uint256 itemDropChance[]; //Drop rate of the item
    uint256 rewardID[]; //reward ID of ERC1155 NFT Token

    address NFTContract_Address;
    mapping(bytes32 => address) private s_rollers;
    mapping(address => uint256) private s_results;
    
    mapping(address => uint256)[] public NumberOfItem;

    
    
    uint256 public randomResult;
    uint256 private constant ROLL_IN_PROGRESS = 42;

    event GachaRolled(bytes32 indexed requestId, address indexed roller);
    event GachaResult(bytes32 indexed requestId, uint256 indexed result);
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */
     
    constructor(bytes32 _keyhash, address _vrfCoordinator, address _linkToken, uint256 _fee) 
        VRFConsumerBase(
            _vrfCoordinator, // VRF Coordinator
            _linkToken  // LINK Token
        ) 
    {
        keyHash = _keyhash;
        // fee = 0.1 * 10 ** 18; // 0.1 LINK
        fee = _fee;
    }

    /** 
     * Requests randomness
     */
     
    function setNFTContractAddr(address _address) public {
       NFTContract_Address = _address;
    }

    //Sum of array to calculate item_drop_rate
    function calcSum(uint256[] arr) public return (uint256 sum) {
        uint256 sum = 0;

        for(uint256 i=0; i<arr.length; i++){
            sum = sum + arr[i];
        }
    }

    // function to add NFT address and amount of NFT to Gacha container 
    function AddItemInGacha(address NFTContract, uint256 amount) public onlyOwner {
        // .safeBatchTransferFrom(deployerAddress, playerAddress, [0,1,3,4], [50,100,1,1], "0x0")

        
    }



   //function sample 

    function sample(uint256[] arr, bytes32 requestId) public return (uint256 index) {
        //check result from player address
        uint256 random = s_results[s_rollers[requestId]]

        uint256 sum = 0; //use sum to find the outcome result

        if(sum > random){
            break;
        }

        index++; 


    }


    function GachaRandomCaller(address roller) public onlyOwner returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK to pay fee");
        require(s_results[roller] == 0, "Already rolled");
        requestId = requestRandomness(keyHash, fee);
        s_rollers[requestId] = roller; // mapping requestId with roller address
        s_results[roller] = ROLL_IN_PROGRESS;
        emit GachaRolled(requestId, roller);
    }
    
    

    /**
     * Callback function used by VRF Coordinator
     */

    
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256 random_result = (randomness % calcSum) + 1;
        s_results[s_rollers[requestId]] = random_result;
        emit GachaResult(requestId, randomResult);
    }

    function sentResultToPlayer(address player) public view returns (string memory) {
        
        require(s_results[player] != 0, "not rolled");
        require(s_results[player] != ROLL_IN_PROGRESS, "Roll in progress");
    } 
}
