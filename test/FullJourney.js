const ControllerContract = artifacts.require("MicroBank")

// Some nice-to-have helpers [[[
// https://github.com/ethereum/web3.js/issues/337
  const BN_ZERO = new web3.utils.BN(0)
  const B322A= (input) => { web3.utils.toAscii(input).replace(/\u0000/g, ''); }// BYTE32→ ASCII
  const A2B32 = function(text) {
      return web3.eth.abi.encodeParameter("bytes32",web3.utils.fromAscii(text)) 
  }
// ]]]

// Helpers functs. to print test statistics [[[
  var assertCount = 0; // Test Stats purposes only
  assert_equal   = function(a,b,c) {
      assertCount++ ; assert.equal  (a,b, c); 
  }
  assert_err     = function(a,b,c) {
      assertCount++ ; assert.isTrue  (a.reason.indexOf(b)==0, c); 
  }
  assert_isTrue  = function(a,b  ) {
      assertCount++ ; assert.isTrue (a,b   ); 
  }
  assert_isFalse = function(a,b  ) {
      assertCount++ ; assert.isFalse(a,b   ); 
  }
// ]]]

MUST_NOT_EXECUTE = { reason : "This code must never be executed. An exception must be raised" }

var MICROBANK; // ← Proxy JS instance:
               //   An "innocent" call to one of its methods will trigger:
               //   local -> local : prepare TX 
               //   local -> wallet: sign tx
               //   local -> local_node  : JSON-RPC call 
               //   local_node -> Eth.network: gossip p2p TX propagation
               //   Eth.network -> Mining node: Block mining with our TX and events
               //   Mining node -> Eth.network: Backwards Block propagation
               //   Eth.network -> local_node : Block 
               //   local_node  -> local_js: [TX receipt + event notification]
contract('MicroBank Contract', accounts => {
  const OWNER_ROLE = accounts[0] 
  const     ACCT01 = accounts[1] 
  const     ACCT02 = accounts[2] 
  const     ACCT03 = accounts[3] 
  const       FUND = new web3.utils.BN(1000) // uint56 in Solidity translates to (B)ig (N)umber is JS/Java/...
  before('setup Contract', async() => {
    MICROBANK = await ControllerContract.new() 
  //                                     ^^^^^ 
  //                                     Trigger new TX to instantiate a contract
  //                                     signed from accounts[0] by default.
  //                                     that will become the owner of the contract
  })

  after('PRINT TEST STATS', () => {
      console.log("assertCount:"+assertCount); // Print stats
  })

  describe('Fund new accounts', () => {
    it("SHOULD FUND PROPERLY FOR OWNER ACCOUNT", async () => {
     //                                          ^^^^^
     //                                          Async STEP 1:
     //                                          - Mark function as async
        const result = await MICROBANK.fundAccount(ACCT01, FUND)
     //                ^^^^^
     //                Async STEP 2:
     //                - Invoque functions returning a Promise with await
     //                  This avoid the callback waterfall (callback nightmare
     //                  in some nomenclature)
        const log0 = result.receipt.logs[0]
        assert_equal(log0.event,"AccountFunded", "")
        assert_equal(log0.args["0"],ACCT01,"")
        assert_equal(log0.args["1"].toString(),FUND.toString(),"")
   })

   it("SHOULD FORBID FUNDS FROM NOT-OWNER ACCOUNT", async () => {
       try {
         await MICROBANK.fundAccount(ACCT01, FUND, {from: ACCT02})
         throw MUST_NOT_EXECUTE
       } catch(err) {
         assert_equal(err.reason, "@EVM,U,ONLY_OWNER_CAN_FUND_ACCOUNTS")
       }
   })
  })

  describe('Transfers amongst users', () => {
    it("SHOULD ALLOW TRANSFER WITH ENOUGH FUND", async () => {
      const result0 = await MICROBANK.fundAccount(ACCT01, FUND)
      const log0 = result0.receipt.logs[0]
      assert_equal(log0.event,"AccountFunded", "")
      assert_equal(log0.args["0"],ACCT01,"")
      assert_equal(log0.args["1"].toString(),FUND.toString()  ,"")
      INITIAL_ACCT01_BALANC = log0.args["2"] ;
      const TRANSFER0 = new web3.utils.BN(100);

      const result1 = await MICROBANK.transferToAccount(ACCT02, TRANSFER0, { from: ACCT01 } )
      const log1 = result1.receipt.logs[0]
      const log2 = result1.receipt.logs[1]
      assert_equal(log1.event,"AccountFunded" , "")
      assert_equal(log2.event,"AccountPayment", "")
      assert_equal(log1.args["0"],ACCT02)
      assert_equal(log1.args["1"].toString(),TRANSFER0.toString()  )
      assert_equal(log2.args["0"],ACCT01)
      assert_equal(log2.args["1"].toString(),TRANSFER0.toString()  )
      const acct01_balance_from_log = log2.args["2"]
      const expected_balance = INITIAL_ACCT01_BALANC - TRANSFER0;
      assert_equal( expected_balance.toString(), acct01_balance_from_log.toString() )
      const acct01_read_balance = await MICROBANK.balanceOf(ACCT01)
      assert_equal( acct01_read_balance.toString(), acct01_balance_from_log.toString() )
    })

    it("SHOULD FORBID TRANSFERS EXCEDING USER BALANCE", async () => {
      try {
        // Since acct03 has not been funded, any transfer must fail
        const result1 = await MICROBANK.transferToAccount(
           ACCT02, new web3.utils.BN(100), { from: ACCT03 } )
        throw MUST_NOT_EXECUTE
      }catch(err) {
        assert_equal(err.reason, "@EVM,U,AMOUNT_GREATER_THAN_SENDER_BALANCE")
      }
    })
  })

})
