usePlugin('@nomiclabs/buidler-waffle')
usePlugin('@nomiclabs/buidler-ethers')
usePlugin("@nomiclabs/buidler-web3")
usePlugin('@openzeppelin/buidler-upgrades')

const privatekey = require('./privatekey.js');

// This is a sample Buidler task. To learn how to create your own go to
// https://buidler.dev/guides/create-task.html
task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners()

  for (const account of accounts) {
    console.log(await account.getAddress())
  }
})

// You have to export an object to set up your config
// This object can have the following optional entries:
// defaultNetwork, networks, solc, and paths.
// Go to https://buidler.dev/config/ to learn more
module.exports = {
  defaultNetwork: privatekey.defaultNetwork,
  networks: {
    local: {
      url: 'http://localhost:7545',
    },
    avalanche: {
      url: privatekey.avaxRPC,
      accounts: [privatekey.privateKey]
    },
    testnet: {
      url: privatekey.avaxtestRPC,
      accounts: [privatekey.privateKey],
      gas: "auto",
      gasPrice: 10000000000,
      // blockGasLimit: 30000000,
      // timeoutBlocks: 200,
    },
  },
  solc: {
    version: '0.8.0',
  },
  paths: {
    artifacts: "./build/contracts",
    tests: './test/unit',
  },
  mocha: {
    timeout: 60000
  }
}
