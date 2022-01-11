# nft-contracts


## Savage Snowman NFT (ERC-721, Avalanche)

Follow the [official instructions] (https://docs.avax.network/build/tutorials/smart-contracts/using-hardhat-with-the-avalanche-c-chain)
to either build the avalanche package manually or install the prebuilt binary

Compile the contracts with `npx hardhat compile`

Launch Avalanche test node: 
1. `git clone git@github.com:ava-labs/avalanchego.git`
2. `cd avalanchego`
3. `./scripts/build.sh`
4. `./build/avalanchego`

To deploy run `npx hardhat run scripts/deploy-savage-snowman.js --network local|fuji|mainnet`
