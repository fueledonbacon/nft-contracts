const bre = require('@nomiclabs/buidler')
const { ethers, web3, upgrades } = bre
const BigNumber = ethers.BigNumber
const Ethers = require('ethers')

const config = require('../../privatekey');

const getReadableNumber = (numberData, decimals = 18) => Ethers.utils.formatUnits(numberData.toString(), decimals).toString()
const getContractNumber = (numberData, decimals = 18) => Ethers.utils.parseUnits(numberData.toString(), decimals).toString()

async function isEthException(promise) {
    let msg = 'No Exception'
    try {
        let x = await promise
        // if (!!x.wait) {
        //     await x.wait()
        // }
    } catch (e) {
        msg = e.message
    }
    return (
        msg.includes('Transaction reverted') ||
        msg.includes('VM Exception while processing transaction: revert') ||
        msg.includes('invalid opcode') ||
        msg.includes('exited with an error (status 0)')
    )
}

async function awaitTx(tx) {
    return await (await tx).wait()
}

async function waitForSomeTime(provider, seconds) {
    await provider.send('evm_increaseTime', [seconds])
}

async function currentTime(provider) {
    const block = await provider.send('eth_getBlockByNumber', ['latest', false])
    return parseInt(block.timestamp, 16)
}

const DECIMALS = 9

function toBASEDenomination(x) {
    return BigNumber.from(x).mul(10 ** DECIMALS)
}

function makeNDigit(num, len) {
    num = num.toString();
    if (!len) len = 2;
    let ret = '';
    for (let i = 0; i < len; i++) ret += '0';

    ret += num;
    ret = ret.substr(-len);
    return ret;
}


var generateRandomString = (len) => {
    if (!len) len = 8;
    var characters = '23456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
    var charactersLength = characters.length;
    var randomString = '';
    for (var i = 0; i < len; i++) {
        randomString += characters[parseInt(Math.random() * charactersLength)];
    }
    return randomString;
};

function makeDateTimeString(dateVal) {
    if (!dateVal) dateVal = new Date();
    return dateVal.getFullYear() + '-' +
        makeNDigit(dateVal.getMonth() + 1) + '-' +
        makeNDigit(dateVal.getDate()) + ' ' +
        makeNDigit(dateVal.getHours()) + ':' +
        makeNDigit(dateVal.getMinutes()) + ':' +
        makeNDigit(dateVal.getSeconds());
}

function formatNumber(num) {
    return num.toLocaleString().replace(/,/g, '');
}

module.exports = {
    ethers,
    web3,
    upgrades,
    BigNumber,
    getReadableNumber,
    getContractNumber,
    isEthException,
    awaitTx,
    waitForSomeTime,
    currentTime,
    toBASEDenomination,
    DECIMALS,
    // myQuery,
    // myQueryFunction,
    generateRandomString,
    makeDateTimeString,
    makeNDigit,
    formatNumber,
}