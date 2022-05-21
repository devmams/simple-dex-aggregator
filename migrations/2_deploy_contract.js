const Aggregator = artifacts.require("Aggregator");

module.exports = async function(deployer){
    await deployer.deploy(Aggregator);
    let aggregator = await Aggregator.deployed();
    let eth_to_weth = await aggregator.getBestRate('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', '1000000000000000000')
    console.log('\n--------- best route to 1 weth usdt to usdc ---------')
    console.log('path : '+ eth_to_weth[0])
    console.log('amountOut : '+eth_to_weth[1].toString())
    console.log('pools : '+eth_to_weth[2])
    let usdt_to_usdc = await aggregator.getBestRate('0xdAC17F958D2ee523a2206206994597C13D831ec7', '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', '1000000000000')
    console.log('\n--------- best route to swap 1000000 usdt to usdc ---------')
    console.log('path : '+ usdt_to_usdc[0])
    console.log('amountOut : '+usdt_to_usdc[1].toString())
    console.log('pools : '+usdt_to_usdc[2])

}
