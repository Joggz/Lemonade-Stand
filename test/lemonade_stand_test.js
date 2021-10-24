const LemonadeStand = artifacts.require("./LemonadeStand.sol");
// console.log(LemonadeStand);

let lemonadestandinstance;
beforeEach(async () => {
  lemonadestandinstance = await LemonadeStand.deployed();
});
contract("lemonade_stand", (accounts) => {
  it("should log instance of contract", async () => {
    console.log(lemonadestandinstance);
    console.log("test passed");
  });
});
