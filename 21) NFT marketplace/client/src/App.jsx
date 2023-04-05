import {BrowserRouter, Routes, Route} from "react-router-dom";
import Navigation from './components/Navbar.jsx';
import Home from './components/Home.jsx'
import Create from './components/Create.jsx'
import MyListedItems from './components/MyListedItems.jsx'
import MyPurchases from './components/MyPurchases.jsx'
import Marketplace from './contracts/Marketplace.json'
import Marketplace_address from './contracts/Marketplaceaddress.json'
import NFT from './contracts/NFT.json'
import NFT_address from './contracts/NFTaddress.json'
import { useState } from 'react'
import Web3 from 'web3'
import { Spinner } from 'react-bootstrap'

import './App.css'

function App() {
  const [loading, setLoading] = useState(true)
  const [account, setAccount] = useState(null)
  const [nft, setNFT] = useState({})
  const [marketplace, setMarketplace] = useState({})

  // MetaMask Login/Connect
const web3Handler = async () => {
  if (window.ethereum) { // if Metamask is installed
  await window.ethereum.enable();
  const web3 = new Web3(window.ethereum);
  const accounts = await web3.eth.getAccounts(); // get array of accounts 
  setAccount(accounts[0]); // setAccount is the useState hook for account state (defined above)
  
  // Get web3provider from Metamask
  const provider = new Web3.providers.Web3Provider(window.ethereum)
  
  // Set signer using getSigner function in the metamask web3 provider 
  const signer = provider.getSigner()
  
  // Handle the event of user changing network in metamask
  window.ethereum.on('chainChanged', (chainId) => {
      window.location.reload(); // reload the dapp (location means URL)
  })
  
  
  // Handle the event of user changing accounts in metamask
  window.ethereum.on('accountsChanged', async function (accounts) {
      setAccount(accounts[0]) // reassign account state to first account in accounts array
      await web3Handler() // reload smart contract with with new address
    })
  
    loadContracts(signer); 
  // load contracts is a function to be defined later. It basically loads the smart contract for the dapp to interact with 
  
  
  } else {
    console.log('No Ethereum interface injected into browser. Read-only access');
  }
  }

  const loadContracts = async (signer) => {
    // Get deployed copies of contracts
    const nft = new Web3.eth.Contract(NFT.abi,NFT_address.address, { from: account }) 
    // the address can also be found in the JSON file directly : NFT.networks[networkId].address
    // here account is the default account variable whose value has been set to accounts[0] some few lines above
    
    
    setNFT(nft)
    
    // Above example is for the nft contract. Repeat the same for other contracts if any.
    
    
    const marketplace = new Web3.eth.Contract(Marketplace.abi,Marketplace_address.address, { from: account })
    setMarketplace(marketplace)
    
    setLoading(false)
  
    }
  
    return (
      <BrowserRouter>
        <div className="App">
          <>
            <Navigation web3Handler={web3Handler} account={account} />
          </>
          <div>
            {loading ? (
              <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '80vh' }}>
                <Spinner animation="border" style={{ display: 'flex' }} />
                <p className='mx-3 my-0'>Awaiting Metamask Connection...</p>
              </div>
            ) : (
              <Routes>
                <Route path="/" element={
                  <Home marketplace={marketplace} nft={nft} />
                } />
                <Route path="/create" element={
                  <Create marketplace={marketplace} nft={nft} />
                } />
                <Route path="/my-listed-items" element={
                  <MyListedItems marketplace={marketplace} nft={nft} account={account} />
                } />
                <Route path="/my-purchases" element={
                  <MyPurchases marketplace={marketplace} nft={nft} account={account} />
                } />
              </Routes>
            )}
          </div>
        </div>
      </BrowserRouter>
  
    );
  }

  export default App;