#!/usr/bin/env bash

## Control this invocation through envvar.
case $RUN_MODE in
  default )
    su -c "lbrycrdd -server -conf=/data/lbrycrd.conf -printtoconsole" lbrycrd
    ;;
  reindex )
    su -c "lbrycrdd -server -txindex -reindex -conf=/data/lbrycrd.conf -printtoconsole" lbrycrd
    ;;
  chainquery )
    su -c "lbrycrdd -server -txindex -conf=/data/lbrycrd.conf -printtoconsole" lbrycrd
    ;;
esac
