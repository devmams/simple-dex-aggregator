# dex-aggregator
Simple contract aggregating 6 uniswapV2 fork (uniswapv2, sushiswap, CroDefiSwap, shibaswap, SakeSwap and Linkswap). </br>
Help to find best route for swapping two tokens onchain. Doing it onchain is not the best way to do but this repos is just for fun.</br>

method : getBestRate(address srcToken, address destToken, uint256 amountIn)</br>
return : [path, amountOut, pools] -> [address[], uint256, address[]]</br>

Example:</br>

srcToken = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2' //WETH</br>
destToken = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48' //USDC</br>
amountIn = 1000000000000000000 // 1 WETH with decimals</br>
getBestRate(srcToken, destToken, amountIn) -> [['0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2','0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', 1955867033, ['0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc']]

