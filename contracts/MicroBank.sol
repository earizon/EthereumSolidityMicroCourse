pragma solidity >=0.5.0 <0.6;

    /*
     * MicroBank allows to fund accounts and transfer
     * money amongst accounts.
     * Each account ID corresponds to an Ethereum public address
     */
contract MicroBank {

    address public owner;

    // Constructor, can receive one or many variables here; only one allowed
    constructor ()  
    public                                                                                                                                
    {   
        // msg provides details about the message that's sent to the contract
        // msg.sender is contract caller (address of contract creator)
        owner     = msg.sender;
     // ^^^^^       ^^^^^^^^^^
     // No this.    All external functions, included constructors, are called through
     // needed      JSON-RPC sending a signed TX. The public address matching the
     //             signed can be fetch as msg.sender
    }

}
