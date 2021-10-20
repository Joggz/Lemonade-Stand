const Lemonade_Stand = artifacts.require("./lemonade_stand.sol");

module.exports = function (deployer) {
  deployer.deploy(Lemonade_Stand);
};
