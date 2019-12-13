#!/bin/bash
# origin	https://steps.everis.com/git/KSBLOCKCH/ethereumsoliditymicrocourse.git 
function funShowFile {
   echo "___________________________________________"
   echo "file $1 :"
   cat $1 | sed "s/^/    /"
}

function funNextSlide {
  read -p "Press [Enter] to continue";  
  clear;
}

function funTitle {
    title="@ ${1} @"
    border=$(echo "$title" | sed "s/./@/g")
    echo "${border}"
    echo $title
    echo "${border}"
    echo ""
    echo ""
}

function funCheckout {
git checkout $1 1>/dev/null 2>&1
}
clear
funCheckout 28a3556df3ee246665a73adbda52bac69da8309b 
funNextSlide
funTitle "Initial Commit"
funShowFile "README.txt"

funCheckout b21de643cea4e3ccb90ef09fc3f56bfefad2bdca
funNextSlide
funTitle "truffle init"
funShowFile contracts/Migrations.sol 
funShowFile migrations/1_initial_migration.js


funCheckout 4bd47f506b5b7639946674aad871486918e60490
funNextSlide
funTitle "Update README.txt. Add info bout ganache"
git diff 28a3556df3ee246665a73adbda52bac69da8309b 4bd47f506b5b7639946674aad871486918e60490 -- README.txt
 

funCheckout 060dd7183f22a7c3a0bdde9678ebaf58928141f0
funNextSlide
funTitle "*Add helper dev. scripts*"
funShowFile launch_local_ganache.sh 
funShowFile launch_local_remixd.sh

funCheckout f5435f5afcdae1d0a3bf845771787df9359ce793
funNextSlide
funTitle "Add Tests ..."
read -p "Press [Enter] to show test/FullJourney.js ";  
cat test/FullJourney.js | vim -

funCheckout c10a233a0c2c6e3be81c6f141e7276d385092952
funNextSlide
funTitle "Add Nude contract and migration scripts"
funShowFile contracts/MicroBank.sol   
funShowFile migrations/2_MicroBank.sol

funCheckout 7ff94efc6a12d3c57fee651f2010b8dff30748fa
funNextSlide 
funTitle "Add constructor and owner to contract"
funShowFile contracts/MicroBank.sol

funCheckout b2d2110a9fee28ba31d781900534ad671850a5e5
funNextSlide 
funTitle "Add expected functionality"
funShowFile contracts/MicroBank.sol

funCheckout 87cac9c2818097ebbd6a4830421248ed04215c26
funNextSlide
funTitle "Add map representing the ledger status"
funShowFile contracts/MicroBank.sol

funCheckout 451b17072a8f5012026df7860eef4dc5478a7ba8
funNextSlide 
funTitle "Implement transaction logic"
funShowFile contracts/MicroBank.sol

funCheckout 33b02ba774d81f2706eeb255c41f774c836cedb3
funNextSlide 
funTitle "Add events"
funShowFile contracts/MicroBank.sol

funCheckout 72a9705f4b3cd978dd330c2cce06191a9379bcef
funNextSlide
funTitle "Add security"
funShowFile contracts/MicroBank.sol

funCheckout aaab16bd86e4e2ee9d8b064f0f9b7700ecfc3bc7
funNextSlide 
funTitle "add read-only method"
funShowFile contracts/MicroBank.sol

# funCheckout f6b6cea0d2f8427798cc87ae49d88f73b928fceb
funCheckout master 
