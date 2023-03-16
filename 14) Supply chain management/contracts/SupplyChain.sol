//SPDX-License-Identifier:GPL-3.0

/* This smart contract tracks products throughout its supply chain starting from
manufacturer to distributor to retailer to customer. At each stage, the product is approved. 
The payments are released by consumer when he recieves the product in right 
condition and same was approved at each stage of supply chain.The price at each stage 
is for the sake of project is set such that each distributor and retailer add 5% above 
manufacturer's price for product handling. However, in real scenario, this price at 
each stage may also be fixed using the smart contract. 

This way, using this contract consumer can track the complete life cycle of product 
and transfer the money only when he is satisfied. 

Also, for identification of the person using the updateProduct function, ID:0 is assigned 
to manufacturer, ID:1 is assigned to distributor, ID:2 is assigned to retailer and ID:3 
is assigned to consumer. In real scenario, this ID can be linked to a verified database.

*/

pragma solidity ^0.8.0;

contract SupplyChain {
    
    
    struct Product {
        uint256 productId;
        string name;
        string description;
        address payable manufacturer;
        address payable distributor;
        address payable retailer;
        address payable consumer;
        bool approveByManufacturer;
        bool approveByDistributor;
        bool approveByRetailer;
        bool approveByCustomer;
        uint256 manufacturerPrice;
    }    
    
    Product[] public products;
    
    
    function createProduct(string memory _name, string memory _description, uint256 _manufacturerPrice,uint _identity) public {
        require(_identity==0,"You are not a manufacturer and hence cant use this function");
        Product memory newProduct = Product({
            productId: products.length,
            name: _name,
            description: _description,
            manufacturerPrice: _manufacturerPrice,
            manufacturer: payable(msg.sender),
            distributor: payable(address(0)),
            retailer: payable(address(0)),
            consumer: payable(address(0)),
            approveByManufacturer:true,
            approveByDistributor:false,
            approveByRetailer:false,
            approveByCustomer:false

        });
        
        products.push(newProduct);
        
    }
    
    
    function updateProduct(uint256 _productId,uint _identity,bool approveProduct) public {
        require(_identity==1 || _identity==2 || _identity==3,"Only distributors, retailers and consumers can use this function");
        Product storage product = products[_productId];
        
        if(_identity==1 && product.approveByManufacturer==true) {
            product.distributor = payable(msg.sender);
            product.approveByDistributor=approveProduct;
        }
        if(_identity==2 && product.approveByManufacturer==true && product.approveByDistributor==true) {
            product.retailer=payable(msg.sender);
            product.approveByRetailer=approveProduct;
        } 

        if(_identity==3 && product.approveByManufacturer==true && product.approveByDistributor==true && product.approveByRetailer==true) {
            product.consumer=payable(msg.sender);
            product.approveByCustomer=approveProduct;
        }   
    }

    function payRetailer(uint _productIndex) public payable {
        require(payable(msg.sender)==products[_productIndex].consumer,"Only consumer can approve the payments");
        require(products[_productIndex].approveByManufacturer==true,"Manufacturer has not approved the product");
        require(products[_productIndex].approveByDistributor==true,"Distributor has not approved the product");
        require(products[_productIndex].approveByRetailer==true,"Retailer has not approved the product");
        require(products[_productIndex].approveByCustomer==true,"Customer has not approved the product");
        products[_productIndex].retailer.transfer(products[_productIndex].manufacturerPrice*105*105/10000);

    }

    function payDistributor(uint _productIndex) public payable {
        require(payable(msg.sender)==products[_productIndex].retailer,"Only retailer can approve the payments");
        require(products[_productIndex].approveByManufacturer==true,"Manufacturer has not approved the product");
        require(products[_productIndex].approveByDistributor==true,"Distributor has not approved the product");
        require(products[_productIndex].approveByRetailer==true,"Retailer has not approved the product");
        require(products[_productIndex].approveByCustomer==true,"Customer has not approved the product");
        products[_productIndex].distributor.transfer(products[_productIndex].manufacturerPrice*105/100);

    }

    function payManufacturer(uint _productIndex) public payable {
        require(payable(msg.sender)==products[_productIndex].distributor,"Only distributor can approve the payments");
        require(products[_productIndex].approveByManufacturer==true,"Manufacturer has not approved the product");
        require(products[_productIndex].approveByDistributor==true,"Distributor has not approved the product");
        require(products[_productIndex].approveByRetailer==true,"Retailer has not approved the product");
        require(products[_productIndex].approveByCustomer==true,"Customer has not approved the product");
        products[_productIndex].manufacturer.transfer(products[_productIndex].manufacturerPrice);

    }

}
