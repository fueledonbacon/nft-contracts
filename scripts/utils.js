const fs = require('fs')
const path = require('path')
const ethers = require('ethers')

const addressFile = 'contract-addresses.json';

const getReadableNumber = (numberData, decimals = 18) => ethers.utils.formatUnits(numberData.toString(), decimals).toString()
const getContractNumber = (numberData, decimals = 18) => ethers.utils.parseUnits(numberData.toString(), decimals).toString()

function getSavedContractAddresses() {
    let json
    try {
        json = fs.readFileSync(path.join(__dirname, `../${addressFile}`))
    } catch (err) {
        json = '{}'
    }
    const addrs = JSON.parse(json)
    return addrs
}

function saveContractAddress(network, contract, address) {
    const addrs = getSavedContractAddresses()
    addrs[network] = addrs[network] || {}
    addrs[network][contract] = address
    fs.writeFileSync(path.join(__dirname, `../${addressFile}`), JSON.stringify(addrs, null, '    '))
}

module.exports = {
    getSavedContractAddresses,
    saveContractAddress,
    getReadableNumber,
    getContractNumber,
}