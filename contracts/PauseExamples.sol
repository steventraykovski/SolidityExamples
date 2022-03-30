//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-ethereum-package/contracts/utils/Pausable.sol";

contract myContractSample {
    // Some string type variables to identify the token.
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // The fixed amount of tokens stored in an unsigned integer type variable.
    uint256 public totalSupply = 1000000;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    // A global variable is created to manage pause capabilities

    bool public paused;

    // A global variable to govern pause capabilities
    bool public canPause = true;


    // A mapping is a key/value map. Here we store each account balance.
    mapping(address => uint256) balances;

    event removePause();
    
    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     * The `public` modifier makes a function callable from outside the contract.
     */
    constructor() {
        // The totalSupply is assigned to transaction sender, which is the account
        // that is deploying the contract.
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from outside
     * the contract.
     */

    // This function allows the contract owner to change the value of the bool variable 'paused'

    function setPaused(bool _paused) public {
        require(msg.sender == owner, "You are not the owner");
       
        require(canPause == true);

        paused = _paused;
    }

    function removePauseCapability() public {
        require(msg.sender == owner, "You are not the owner");

        paused = false;
        canPause = false;
        
        emit removePause();
    }



    // Transfer function example with pausing enabled locally in contract 

    function transfer1(address to, uint256 amount) external {
        
        require(paused == false, "Function Paused");
        require(balances[msg.sender] >= amount, "Not enough tokens");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    // Transfer function example with pausing enabled via Pausable.sol
    
    function transfer2(address to, uint256 amount) external whenNotPaused {
        
        require(balances[msg.sender] >= amount, "Not enough tokens");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
