#!/bin/bash

#  launch local ganache with predefined accounts, gasprice,..."

LOGS=/tmp/ganache_cli.log
  OPTS=""
  OPTS="$OPTS --gasLimit 6721975" # default: 6721975
  OPTS="$OPTS --host 127.0.0.1"
  OPTS="$OPTS --port 8545"
# OPTS="$OPTS --verbose"
# OPTS="$OPTS --noVMErrorsOnRPCResponse" # reporting behaviour compatible with geth,Parity,...
  OPTS="$OPTS --blockTime 5" # Do not "instant-mine"  new block for every transaction.
  OPTS="$OPTS --allowUnlimitedContractSize" # Do not "instant-mine"  new block for every transaction.
# account list matching
# mnemonic: 'filter climb system senior toddler image around panther senior dust thought fault'
OPTS="$OPTS --account 0x5e13ba5bfbdfb72ee2fec06e50a6ba1745d95db6d43d8710f5a9dd6be540f11d,10000000000000000000000000000"
OPTS="$OPTS --account 0xb1d62891d7dff40d67c3d5a5cef81e0f4e7aef2b4a1f02809f98be1b20acae61,10000000000000000000000000000"
OPTS="$OPTS --account 0xb2430dbb396705006ce571b92a92d09c07b704c17b196648badb108621999510,10000000000000000000000000000"
OPTS="$OPTS --account 0xb075a2c51df83a11feceefda4a5ebc0bb5499370792f0c7421c02dfc7e58c6fc,10000000000000000000000000000"

# "Miner" account for PantheonQuickStart
OPTS="$OPTS --account 0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63,10000000000000000000000000000"

OPTS="$OPTS --gasPrice 0"

EXISTING_PID=$(ps -ef | egrep "(n)ode.*ganache" | while read user pid other ; do echo $pid ; done)

if [ ! -z $EXISTING_PID ] ; then
  echo "ganache process detected with PID: $EXISTING_PID "
  echo "Kill it?"
  select  killExisting  in yes no 
  do 
    if [[ $killExisting  == "yes" ]] ; then
      kill $EXISTING_PID || sleep 1; kill -9 $EXISTING_PID
      break
    else
      exit 1
    fi
  done 

fi
( ganache-cli $OPTS 1>$LOGS 2>&1 ) &

echo "Logs redirected to $LOGS"
echo "  tail -f $LOGS to see them"


#  --debug        Output VM opcodes for debugging  [boolean] [default: false]
