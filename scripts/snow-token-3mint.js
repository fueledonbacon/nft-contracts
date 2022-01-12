const { getSavedContractAddresses } = require("./utils");

const contractName = 'SnowToken'

async function main() {

    const [deployer] = await ethers.getSigners();

    console.log(`${contractName} mint with the account:`, deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const allAddress = getSavedContractAddresses()

    const contract = await ethers.getContractAt(contractName, allAddress[network.name][contractName])

    await contract.mintAll();

    console.log(`${contractName} minted:`, contract.address)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
