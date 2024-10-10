// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract StakingContract{
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;

    constructor(address _stakingToken, address _rewardToken){
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    /// this event will emitted when user stake tokens
    event Staked(address _from, uint256 amount);
    /// this event will emitted when user unstake tokens.
    event Unstaked(address _from, uint256 amount);
    /// this event will emitted when user claimed the reward tokens.
    // event RewardClaimed(address, rewardAmount);
    // /// this event will emitted when user emergency unstake tokens without reward.
    // event EmergencyUnstake(address, amount);
    // /// this event will emitted when reward claimed status will be updated.abi
    // event ClaimedRewardStatusUpdate(bool);

    mapping (address => uint) public userBalance;
    mapping(address => uint) public balanceDepositTimestamps;

    uint256 public constant rewardRatePerSecond = 0.1 ether;
    uint256 public totalReward;
    uint256 public currentBlock = 0;
    uint256 public depositDeadline = block.timestamp + 120 seconds;
    uint256 public claimableDeadline = block.timestamp + 240 seconds;

    modifier depositDeadlineReached( bool requireReached ) {
        uint256 timeRemaining = depositTimeleft();
        if( requireReached ) {
            require(timeRemaining == 0, "Withdrawal period is not reached yet");
        } else {
            require(timeRemaining > 0, "Withdrawal period has been reached");
        }
        _;
    }

    modifier claimDeadlineReached( bool requireReached ) {
        uint256 timeRemaining = claimPeriodLeft();
        if( requireReached ) {
            require(timeRemaining == 0, "Claim deadline is not reached yet");
        } else {
            require(timeRemaining > 0, "Claim deadline has been reached");
        }
        _;
    }

//   modifier notCompleted() {
//     bool completed = exampleExternalContract.completed();
//     require(!completed, "Stake already completed!");
//     _;
//   }

    function depositTimeleft() public view returns(uint256 depositTimeleft){
        if(block.timestamp > depositDeadline){
            return (0);
        }else{
            return (depositDeadline - block.timestamp);
        }
    }

    function claimPeriodLeft() public view returns(uint256 claimPeriodLeft){
        if(block.timestamp > claimableDeadline){
            return (0);
        }else{
            return (claimableDeadline - block.timestamp);
        }
    }

    // call this function to stake token
    function stakeToken() public payable depositDeadlineReached(false) claimDeadlineReached(false){
        userBalance[msg.sender] = userBalance[msg.sender] + msg.value;
        balanceDepositTimestamps[msg.sender] = block.timestamp;
        emit Staked(msg.sender, msg.value);
    }

    // Unstake funciton will help you to unstake token with the
    // principle amount + reward token
    function unstakeToken() public depositDeadlineReached(true) claimDeadlineReached(false){
        require(userBalance[msg.sender] > 0, "You haven't stake any token yet!!");
        uint256 individualBalance = userBalance[msg.sender];
        uint256 userBalacePlusReward = individualBalance + ((block.timestamp - balanceDepositTimestamps[msg.sender])*rewardRatePerSecond);
        userBalance[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value:userBalacePlusReward}("");
        require(sent, "Fail to transfer token");
        emit Unstaked(msg.sender, userBalacePlusReward);
    }

    // add this Additional Functionality
    function rewardClaim() public payable{}
    function emergencyUnstakeToken()public payable {}
}


