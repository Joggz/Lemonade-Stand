import React, { Component } from "react";
// import SimpleStorageContract from "./contracts/SimpleStorage.json";
import LemonadeStand from "./contracts/LemonadeStand.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { web3: null, accounts: null, contract: null, name: "", price: 0 };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();
      console.log("accounts ======>", accounts);
      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = LemonadeStand.networks[networkId];
      const instance = new web3.eth.Contract(
        LemonadeStand.abi,
        deployedNetwork && deployedNetwork.address
      );

      console.log(instance);

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      // UPDATES STATE
      this.setState({ web3, accounts, contract: instance });
      // setTimeout(() => {
      //   this.getAllItems();
      // }, 1000);
      // this.getAllItems();
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, contract } = this.state;

    // Stores a given value, 5 by default.
    // await contract.methods.set(90).send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    // const response = await contract.methods.get().call();

    // Update state with the result.
    // this.setState({ storageValue: response });
  };
  addItems = async (e) => {
    e.preventDefault();
    const { accounts, contract, name, price } = this.state;

    const response = await contract.methods
      .addItem(name, price)
      .send({ from: accounts[0] });
    console.log(response);
  };

  getAllItems = async () => {
    const { accounts, contract, name, price } = this.state;
    console.log(accounts, accounts[0]);
    const getItems = await contract.methods
      .getAllItems()
      .send({ from: accounts[0] });

    console.log("=====>all items ====>", getItems);
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <form onSubmit={this.addItems}>
          <label htmlFor="fname"> Name:</label>
          <input
            type="text"
            id="fname"
            name="fname"
            onChange={(e) => this.setState({ name: e.target.value })}
          />
          <br></br>
          <label htmlFor="lname">Price:</label>
          <input
            type="text"
            id="lname"
            name="lname"
            onChange={(e) => this.setState({ price: Number(e.target.value) })}
          />
          <br></br>
          <input type="submit" value="Submit" />
        </form>

        <button onClick={this.getAllItems}>Get ALl Item</button>
        {/* <h1> LEMONADE STAND .</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of 5 (by default).
        </p> */}
        {/* <p>
          Try changing the value stored on <strong>line 42</strong> of App.js.
        </p>
        <div>The stored value is: {this.state.storageValue}</div> */}
      </div>
    );
  }
}

export default App;
