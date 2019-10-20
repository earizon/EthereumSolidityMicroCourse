#!/bin/bash

#  launch local ganache with predefined accounts, gasprice,..."

LOGS=/tmp/remixd.log
OPTS=""
OPTS="${OPTS} "
OPTS="${OPTS} -s $(pwd) "
OPTS="${OPTS} --remix-ide http://remix.ethereum.org "

remixd ${OPTS} 1>${LOGS} 2>&1 &

