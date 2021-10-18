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

    


}
