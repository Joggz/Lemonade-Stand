const LemonadeStand = artifacts.require("./LemonadeStand.sol");
// console.log(LemonadeStand);

let lemonadestandinstance;
beforeEach(async () => {
  lemonadestandinstance = await LemonadeStand.deployed();
});
contract("lemonade_stand", (accounts) => {
  it("should log instance of contract", async () => {
    // console.log(lemonadestandinstance);
    console.log("test passed");
  });
  it("should return add an Item", async () => {
    let item = await lemonadestandinstance.addItem("lems_ex", 20);
    console.log(item, item.receipt.rawLogs[0].data);
  });
  // it("should get item by sku", async () => {
  //   const item = await lemonadestandinstance.fetchItem(20);
  //   console.log(item);
  // });
  // it("should create an item", async () => {
  //   let createItem = await lemonadestandinstance.addItem("lemo-x", 120);
  //   console.log("======>item created", createItem);
  // });
});
