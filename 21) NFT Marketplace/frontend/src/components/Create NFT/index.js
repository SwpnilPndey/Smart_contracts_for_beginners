import React from 'react'
import './createnft.css'

const Create = () => {
  return (
    <div className='create-nft'>

      <div className='component-heading'>
        Fill below details to create an NFT
      </div>

      

        <div className='form-control'>
          
          <input type='text' placeholder='Browse to upload NFT' />

        </div>

        <div className='form-control'>
          
          <input type='text' placeholder='Enter name of NFT' />

        </div>

        <div className='form-control'>
          
          <input type='textarea' placeholder='Enter description of NFT' />

        </div>

        <div className='form-control'>
          
          <input type='text' placeholder='Enter selling price of NFT' />

        </div>

      


    </div>
    
  )
}

export default Create