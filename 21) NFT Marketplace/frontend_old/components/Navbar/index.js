import React from 'react'
import { Link } from 'react-router-dom';

import './navbar.css'

const Navbar = () => {
  return (
    <div className='navbar'>


      <div className='logo'><span className='logo-name'> NFT Marketplace </span>
        <img src='https://w7.pngwing.com/pngs/360/639/png-transparent-baby-art-infant-child-baby-boy-baby-announcement-card-food-face.png' className='img' />
      </div>

      <div className='navbar-links'>

        <div>
          <Link to="/Create">
            Create NFTs
          </Link>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        
        <div>
          <Link to="/ListedNFTs">
            Listed NFTs
          </Link>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <div>
          <Link to="/PurchaseNFTs">
            Purchase NFTs
          </Link>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

        <div className='metamask-button'>
        
          <input type='button' value="Connect Wallet"/>


        </div>

      </div>


    </div>
  )
}

export default Navbar