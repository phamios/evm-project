// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)
pragma solidity ^0.8.0;

/* 
psedo code of swap contract by swapping TokenA and TokenB which is of type IERC20

4 step to implement swap of 2 tokens-
-> First check user have the same token which contract support.
-> Transfer the tokenA from user account to contract account using transferFrom().
-> Calculate the amountIn by user. By subtracting reserve balance with the new balance.
-> Calculate the amoutOut including 0.3% Fee.
-> Update reserve value of respective tokens.
-> Transfer the tokenB to the user by calling tranfer()
*/

contract SwapTokens{
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public totalSupply;
    mapping (address => uint) public balanceOf;

    uint public reserve0;
    uint public reserve1;

    constructor(address _token0, address _token1){
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function burn(address _from, uint _amount) private{
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function updateReverseValue(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(address _tokenIn, uint _amountIn) external returns(uint amountOut){
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "invalie token");

        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut) = isToken0 ? (token0, token1) : (token1, token0);

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountIn = tokenOut.balanceOf(address(this)) - reserve0;

        // calculate tokenOut including (0.3% fee)
        amountOut = (amountIn*997)/1000;

        // update reserve value
        if(_tokenIn == address(token0)){
            updateReverseValue(reserve0 + _amountIn, reserve1 - amountOut);
        }else{
            updateReverseValue(reserve0 - _amountIn, reserve1 + amountOut);
        }
        // transfer amoutOut  
        tokenOut.transfer(msg.sender, amountOut);
    }
}

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}