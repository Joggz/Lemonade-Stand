// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

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

Item [] lemonades;
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
    modifier checkCustomerShouldRecieveChange(uint sku){
        uint price = items[sku].price;
        uint amountToRefund = msg.value - price;
       payable( items[sku].buyer).transfer(amountToRefund);
        _;
    }

    function addItem( string memory  _name, uint _price) onlyOwner public{
        skucount = skucount + 1;

        emit Forsale(skucount);

        items[skucount] = Item({name: _name, sku: skucount, price: _price, state: State.forsale, seller: Owner, buyer: address(0)});
    }

//   not sure about this block of code, but i intend to get all items from the mapping.

    // function getAllItems() public view returns(string[] memory, uint[] memory, uint[] memory, uint[] memory, address[] memory, address[] memory ){
    //     string[] memory names = new string[](skucount);
    //     uint[] memory skus  = new uint[](skucount);
    //     uint[] memory price = new uint[](skucount);
    //     uint[] memory state = new uint[](skucount);
    //     address[] memory sellers = new address[](skucount);
    //     address[] memory buyers = new address[](skucount);

    //     for (uint256 index = 0; index < skucount; index++) {
    //          Item storage lemo = lemonades[index];
    //          names[index] = lemo.name;
    //           skus[index] = lemo.sku;
    //            price[index] = lemo.price;
    //             state[index] = uint(lemo.state);
    //              sellers[index] = lemo.seller;
    //               buyers[index] = lemo.buyer;
            
    //     }
        

    //     return (names, skus, price, state, sellers, buyers);
    // }
   

    function buyItem(uint sku) forSale(sku) paidEnough(items[sku].price) checkCustomerShouldRecieveChange(sku) payable public {
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

        return (name, sku, stateIs, seller, buyer); 
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
   
