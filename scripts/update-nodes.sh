#!/bin/bash

SHA1=6d78c57a
BTC_URL=http://example.com/BUcash-1.1.1-linux64-${SHA1}.tar.gz
BTC_URL_DBG=http://example.com/bitcoind-x86_64-linux-gnu-${SHA1}.debug

# deploy the binaries with debug symbol?
DBG=1

cd /tmp
wget -nv "$BTC_URL" -O bitcoin.tar.gz
wget -nv "$BTC_URL_DBG" -O bitcoind.dbg

echo "Stopping bitcoind via systemd..."
sudo service bitcoind stop
sudo service bitcoind-dbg stop
echo "Kill it, just in case...."
sudo killall -9 bitcoind
sudo killall -9 bitcoind.dbg

echo "Installing the new bins..."
tar xf bitcoin.tar.gz
sudo install BUcash-*/bin/* /usr/local/bin/
sudo cp bitcoind.dbg /usr/local/bin/
sudo chmod +x /usr/local/bin/bitcoind.dbg

# Update conf if needed
# e.g. adding conf par to the bitcoin.conf file or chaning some par value
#echo "mining.unsafeGetBlockTemplate=1" >> /home/nol/.bitcoin/bitcoin.conf

echo "Starting the new bitcoind version...."
if [ $DBG -eq 1 ]
then
  sudo service bitcoind-dbg start
else
  sudo service bitcoind start
fi

#clean up
sudo rm -rf bitcoin*
sudo rm -rf BUcash-*
