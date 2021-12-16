const { saveContractAddress, getContractNumber } = require("./utils");

const contractName = 'SnowToken'

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log(`Deploying ${contractName} contracts with the account:`, deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Contract = await ethers.getContractFactory(contractName)

    const contract = await Contract.deploy(
        'Lodge Token', '$LODGE', // name, symbol
        getContractNumber('250000000'), // total cap
    );
    
    saveContractAddress(network.name, contractName, contract.address)

    console.log(`${contractName} deployed to address:`, contract.address)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
