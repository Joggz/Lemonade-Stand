const LemonadeStand = artifacts.require("./LemonadeStand.sol");

module.exports = async function (deployer) {
  let s = await deployer.deploy(LemonadeStand);
  console.log(s);
};
