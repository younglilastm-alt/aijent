// Import web3
import Web3 from 'web3';

async function connectWallet() {
    if (window.ethereum) {
        try {
            // Request account access
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            const web3 = new Web3(window.ethereum);
            console.log('Wallet connected!');
            return web3;
        } catch (error) {
            console.error('User denied account access:', error);
        }
    } else {
        console.error('No Ethereum wallet detected. Please install MetaMask!');
    }
}

async function interactWithContract(web3) {
    const contractAddress = 'YOUR_CONTRACT_ADDRESS';
    const contractABI = []; // Replace with your contract ABI

    const contract = new web3.eth.Contract(contractABI, contractAddress);

    // Example function call to the contract
    try {
        const response = await contract.methods.YOUR_METHOD_NAME().call();
        console.log('Response from contract:', response);
    } catch (error) {
        console.error('Error interacting with the contract:', error);
    }
}

async function initApp() {
    const web3 = await connectWallet();
    if (web3) {
        interactWithContract(web3);
    }
}

window.addEventListener('load', () => {
    initApp();
});