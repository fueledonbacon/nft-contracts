const bre = require('@nomiclabs/buidler')
const { ethers, awaitTx, } = require('./utils/setup')
const privateKey = require('../../privatekey');

async function main() {
  const address = privateKey[bre.network.name];
  const accounts = await ethers.getSigners();
  const _owner = await accounts[0].getAddress();
  console.log('----- owner address: ', _owner);
  console.log('--- chain: ', bre.network.name, address.nftToken);
  let mainContract = await ethers.getContractAt('MultiSigWallet', address.multiSigWallet);

  await (awaitTx(
    mainContract.appendSigner([
      '0x1FF0a45474f1588922aF70DE2ee78036193f289e',
      '0x234cD3A5335B590872f7888d8E72DbA72492190b',
    ])
  ));
  
  console.log('--- multisig signer configured success ');
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
