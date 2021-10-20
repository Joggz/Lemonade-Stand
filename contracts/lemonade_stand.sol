// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

contract LemonadeStand {
    address Owner;
    uint skucount;
    // address buyer;

    enum State { forsale, sold, shipped}

    struct Item { 
        string name;
        uint sku;
        uint price;
        State state;
        address seller;
        address buyer;
    }

    mapping (uint => Item) items;

    // events

    event Forsale(uint skucount);
    
    event sold(uint sku);

    event shipped(uint sku);

    constructor () {
        Owner = msg.sender;
        skucount = 0;
    }

    modifier onlyOwner () {
        require(msg.sender == Owner);
        _;
    }

    modifier verifyCaller(address _address) {
        require(msg.sender == _address);
        _;
    }

    modifier paidEnough(uint _price) {
        require(msg.value >= _price);
        _;
    }

    modifier forSale(uint _sku) {
        require(items[_sku].state == State.forsale);
        _;
    }

    modifier Sold(uint _sku) {
        require(items[_sku].state == State.sold);
        _; 
    }

    function addItem( string memory  _name, uint _price) onlyOwner public{
        skucount = skucount + 1;

        emit Forsale(skucount);

        items[skucount] = Item({name: _name, sku: skucount, price: _price, state: State.forsale, seller: Owner, buyer: address(0)});
    }

    function buyItem(uint sku) forSale(sku) paidEnough(items[sku].price) payable public {
      address   buyer = msg.sender;

        uint price = items[sku].price;
        items[sku].buyer = buyer;

        items[sku].state = State.sold;

        skucount = skucount - 1;

       payable(items[sku].seller).transfer(price);

        emit sold(sku);
    }

 function fetchItem(uint _sku) public view returns(string memory name, uint sku, string  memory stateIs, address seller, address buyer){
        uint state;

        name = items[_sku].name;
        sku = items[_sku].sku;
       
        state = uint(items[_sku].state);

        if(state == 0){
            stateIs = "For Sale";
        }

        if(state == 1) {
            stateIs = "Sold";
        }
        seller = items[_sku].seller;
        buyer  = items[_sku].buyer;
    }

    function shipItem(uint _sku)  public  Sold(_sku) verifyCaller(items[_sku].seller) returns(string memory stateIs) {
         uint state;

         items[_sku].state = State.shipped;
        state = uint(items[_sku].state);

        if(state == 3){
            stateIs = "Item shipped";
        }

        emit shipped(_sku);
    }   

}
   



// https://api-m.sandbox.paypal.com/v1/reporting/transactions?start_date=2021-10-17T00:00:00-0700&end_date=2021-10-19T23:59:59-0700