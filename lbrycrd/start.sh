#!/usr/bin/env bash

## Control this invocation through envvar.
case $RUN_MODE in
  default )
    lbrycrdd -server -conf=/etc/lbry/lbrycrd.conf -printtoconsole
    ;;
  reindex )
    lbrycrdd -server -txindex -reindex -conf=/etc/lbry/lbrycrd.conf -printtoconsole
    ;;
  chainquery )
    lbrycrdd -server -txindex -conf=/etc/lbry/lbrycrd.conf -printtoconsole
    ;;
esac
