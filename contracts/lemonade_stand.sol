// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

contract LemonadeStand {
    address Owner;
    uint skucount;
    address buyer;

    enum State { forsale, sold}

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

        items[skucount] = Item({name: _name, sku: skucount, price: _price, state: State.forsale, seller: msg.sender, buyer: address(0)});
    }


}
