
const SnowToken = artifacts.require('SnowToken');
module.exports = async function (deployer, networkName, accounts) {
  await deployer.deploy(SnowToken, 'Lodge Token', '$LODGE');
};