const Aggregator = artifacts.require("Aggregator");

module.exports = async function(deployer){
    await deployer.deploy(Aggregator);
    let aggregator = await Aggregator.deployed();
    // console.log(aggregator)
    console.log(await aggregator.getBestRate('0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', '1000000000000000000'))
    console.log(await aggregator.getBestRate('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', '1000000000000000000'))
    console.log(await aggregator.getBestRate('0xdAC17F958D2ee523a2206206994597C13D831ec7', '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', '10000000000'))
}
