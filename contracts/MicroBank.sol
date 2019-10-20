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

    // Events - publicize actions to external listeners
    event AccountFunded  (address accountAddress, uint amount, uint finalBalance);
    event AccountPayment (address accountAddress, uint amount, uint finalBalance);

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
        require (owner == msg.sender, "@EVM,U,ONLY_OWNER_CAN_FUND_ACCOUNTS");
        LEDGER[destAccount] = LEDGER[destAccount]+amount; 
        emit AccountFunded(destAccount, amount, LEDGER[destAccount]); 
    }

    function transferToAccount(address destAccount, uint amount) 
    public 
    {
        require(LEDGER[msg.sender] >= amount, "@EVM,U,AMOUNT_GREATER_THAN_SENDER_BALANCE");
        LEDGER[msg.sender]  = LEDGER[msg.sender]  - amount;
        LEDGER[destAccount] = LEDGER[destAccount] + amount;
        
        emit AccountFunded  (destAccount , amount, LEDGER[destAccount]);
        emit AccountPayment (msg.sender  , amount, LEDGER[msg.sender]  );
    }

    function balanceOf(address accountAddress) 
    view   // <- View: No state is modified => No mining needed 
    public //          => Can be run locally and in parallel.
    returns (uint) {
        return uint(LEDGER[accountAddress]);
    }   
}
