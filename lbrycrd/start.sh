#!/usr/bin/env bash

## Control this invocation through envvar.
case $RUN_MODE in
  default )
    lbrycrdd -server -conf=/data/lbrycrd.conf -printtoconsole
    ;;
  reindex )
    lbrycrdd -server -txindex -reindex -conf=/data/lbrycrd.conf -printtoconsole
    ;;
  chainquery )
    lbrycrdd -server -txindex -conf=/data/lbrycrd.conf -printtoconsole
    ;;
esac
