#!/usr/bin/env bash

## Set config params
## TODO: Make this more automagic in the future.
echo "rpcuser=$RPC_USER" > /data/.lbrycrd/lbrycrd.conf
echo "rpcpassword=$RPC_PASSWORD" >> /data/.lbrycrd/lbrycrd.conf
echo "rpcallowip=$RPC_ALLOW_IP" >> /data/.lbrycrd/lbrycrd.conf
echo "rpcport=9245" >> /data/.lbrycrd/lbrycrd.conf
echo "rpcbind=0.0.0.0" >> /data/.lbrycrd/lbrycrd.conf
#echo "bind=0.0.0.0" >> /data/.lbrycrd/lbrycrd.conf

## Control this invocation through envvar.
case $RUN_MODE in
  default )
    su -c "lbrycrdd -server -conf=/data/.lbrycrd/lbrycrd.conf -printtoconsole" lbrycrd
    ;;
  reindex )
    su -c "lbrycrdd -server -txindex -reindex -conf=/data/.lbrycrd/lbrycrd.conf -printtoconsole" lbrycrd
    ;;
  chainquery )
    su -c "lbrycrdd -server -txindex -conf=/data/.lbrycrd/lbrycrd.conf -printtoconsole" lbrycrd
    ;;
esac
