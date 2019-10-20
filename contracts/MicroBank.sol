pragma solidity >=0.5.0 <0.6;

    /*
     * MicroBank allows to fund accounts and transfer
     * money amongst accounts.
     * Each account ID corresponds to an Ethereum public address
     */
contract MicroBank {

    mapping                  (address /*account owner*/ => uint /*account balance*/) private LEDGER;
//  ^^^^^^^                   ^^^^^^^                      ^^^^^^                      ^^^^^^^
// key/value structure        key type                     value type                visibility:
// Java Map/Python Dict/...                                                      - internal: this contract and children
//                                                                               - private : this contract
//                                                                               - public  : readable to any contract 
//                                                                                           and JSON-RPC clients
//                                                                                           outside the EVM 

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

    function fundAccount(address destAccount, uint amount) 
    public
    {
        LEDGER[destAccount] = LEDGER[destAccount]+amount; 
    }

    function transferToAccount(address destAccount, uint amount) 
    public 
    {
        LEDGER[msg.sender]  = LEDGER[msg.sender]  - amount;
        LEDGER[destAccount] = LEDGER[destAccount] + amount;
    }
}
