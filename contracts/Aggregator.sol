//SPDX-license-Identifier: MIT
pragma solidity 0.7.5;

import './libraries/SafeMath.sol';
import './interfaces/IERC20.sol';
import './interfaces/IUniswapV2Factory.sol';
import './interfaces/IUniswapV2Pair.sol';

contract Aggregator {
    using SafeMath for uint256;

    address[] public dexs;
    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public ZERO = 0x0000000000000000000000000000000000000000;

    constructor() {
        dexs.push(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); //UniSwapV2
        dexs.push(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac); //SushiSwap
        dexs.push(0x9DEB29c9a4c7A88a3C0257393b7f3335338D9A9D); //CroDefiSwap
        dexs.push(0x115934131916C8b277DD010Ee02de363c09d037c); //ShibaSwap
        dexs.push(0x75e48C954594d64ef9613AeEF97Ad85370F13807); //SakeSwap
        dexs.push(0x696708Db871B77355d6C2bE7290B27CF0Bb9B24b); //Linkswap
    }

    function getBestRate(address srcToken, address destToken, uint256 amountIn) external view returns(bytes memory result){
        require(srcToken != destToken, "srcToken and destToken must not be the same");
        require(amountIn > 0, "amountIn must be greater than zero");
        if((srcToken == ETH && destToken == WETH) || (srcToken == WETH && destToken == ETH)){
            result = abi.encode([srcToken, destToken], amountIn, [WETH]);
        }else{
            address _srcToken = srcToken == ETH ? WETH: srcToken;
            address _destToken = destToken == ETH ? WETH: destToken;

            // get best rate with 0 connector
            (bytes memory result0, uint256 amountOut0) = getBestRate0Connector(_srcToken, _destToken, amountIn);
            result = amountOut0 > 0 ? abi.encode([srcToken, destToken], amountOut0, result0) : abi.encode(ZERO);

            // get best rate with 'WETH' connector when srcToken && destToken != WETH
            if(_srcToken != WETH && _destToken != WETH){
                (bytes memory result1, uint256 amountOut1) = getBestRate1Connector(_srcToken, _destToken, amountIn);
                result = amountOut1 > amountOut0 ? abi.encode([srcToken, WETH, destToken], amountOut1, result1) : result;
            }
        }
    }

    function getBestRate0Connector(address srcToken, address destToken, uint256 amountIn) internal view returns(bytes memory result, uint256 amountOut){
        amountOut = 0;
        address pair;
        for(uint i=0; i<dexs.length; i++){
            address _pair = IUniswapV2Factory(dexs[i]).getPair(srcToken, destToken);
            if(_pair != ZERO){
                (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(_pair).getReserves();
                (reserve0, reserve1) = srcToken > destToken ? (reserve1, reserve0) : (reserve0, reserve1);
                uint256 _amountOut = getAmountOut(amountIn, reserve0, reserve1);
                if(_amountOut > amountOut){
                    amountOut = _amountOut;
                    pair = _pair;
                }
            }
        }
        result = amountOut > 0 ? abi.encode([pair]) : abi.encode(ZERO);
    }

    function getBestRate1Connector(address srcToken, address destToken, uint256 amountIn) internal view returns(bytes memory result, uint256 amountOut){
        amountOut = 0;
        address pair0;
        address pair1;
        for(uint i=0; i<dexs.length; i++){
            address _pair0 = IUniswapV2Factory(dexs[i]).getPair(srcToken, WETH);
            address _pair1 = IUniswapV2Factory(dexs[i]).getPair(WETH, destToken);
            if(_pair0 != ZERO && _pair1 != ZERO){
                (uint112 reserve00, uint112 reserve01,) = IUniswapV2Pair(_pair0).getReserves();
                (uint112 reserve10, uint112 reserve11,) = IUniswapV2Pair(_pair1).getReserves();
                (reserve00, reserve01) = srcToken > WETH ? (reserve01, reserve00) : (reserve00, reserve01);
                (reserve10, reserve11) = WETH > destToken ? (reserve11, reserve10) : (reserve10, reserve11);
                uint256 _amountOut = getAmountOut(getAmountOut(amountIn, reserve00, reserve01), reserve10, reserve11);
                if(_amountOut > amountOut){
                    amountOut = _amountOut;
                    pair0 = _pair0;
                    pair1 = _pair1;
                }
            }
        }
        result = amountOut > 0 ? abi.encode([pair0, pair1]) : abi.encode(ZERO);
    }

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal pure returns (uint256 amountOut){
        uint256 amountInWithFee = amountIn.mul(997);
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = uint256(numerator / denominator);
    }
}





















//
