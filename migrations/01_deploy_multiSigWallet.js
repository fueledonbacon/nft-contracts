
const MultiSigWallet = artifacts.require('MultiSigWallet');
module.exports = async function (deployer, networkName, accounts) {
  await deployer.deploy(MultiSigWallet);
};