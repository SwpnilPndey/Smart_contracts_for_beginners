import React from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import './App.css'
import Navbar from "./components/Navbar"
import Create from "./components/Create NFT"
import ListedNFTs from "./components/Listed NFTs"
import PurchaseNFTs from "./components/Purchase NFT"



const App = () => {


  return (
    <BrowserRouter>
      <div>


        <Navbar />
        <br />

        <Routes>




          <Route path="/Create" element={<Create />} />
          <Route path="/ListedNFTs" element={<ListedNFTs />} />
          <Route path="/PurchaseNFTs" element={<PurchaseNFTs />} />


        </Routes>







      </div>

    </BrowserRouter>
  )
}

export default App