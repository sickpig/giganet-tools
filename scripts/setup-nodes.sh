#!/bin/bash

## redirect stdout to a log file
exec > /tmp/deploy_log.txt

## UPDATE THE SYSTEM

SHA1=acs2sd45
BTC_URL=http://exammple.com/BUcash-1.1.1-linux64-${SHA1}.tar.gz
BTC_URL_DBG=http://example.com/bitcoind-x86_64-linux-gnu-${SHA1}.debug

NODE_USER1="nol"
NODE_PASSWORD="thisisasupersecretpwd"

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

DEBIAN_FRONTEND=noninteractive apt-get -y install vim htop libgoogle-perftools-dev
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove

## PREPARE BU INSTALLATION

adduser --disabled-password --gecos "" $NODE_USER1

# disable ssh root login

echo "$NODE_USER1:$NODE_PASSWORD" | chpasswd
usermod -aG sudo $NODE_USER1

#hardened ssh a bit
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/#PasswordAuthentication no/' /etc/ssh/sshd_config
service ssh reload

## No pwd for sudo
cp /etc/sudoers /etc/sudoers.bak
cp /etc/sudoers /etc/sudoers.tmp

chmod 0640 /etc/sudoers.tmp
echo "$NODE_USER1 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.tmp
chmod 0440 /etc/sudoers.tmp
cp /etc/sudoers.tmp /etc/sudoers

# ssh key exchange
mkdir /home/$NODE_USER1/.ssh
cat << EOF > /home/$NODE_USER1/.ssh/authorized_keys
put your ssh public key here
EOF

chown $NODE_USER2.$NODE_USER1 -R /home/$NODE_USER1/.ssh/
chmod 600 /home/$NODE_USER2/.ssh/authorized_keys

# install BU

wget "$BTC_URL" -O bitcoin.tar.gz
wget "$BTC_URL_DBG" -O bitcoind.dbg
tar xf bitcoin.tar.gz

install BUcash-*/bin/* /usr/local/bin/
sudo cp bitcoind.dbg /usr/local/bin/

rm -rf bitcoin*
rm -rf BUcash-*


# Configuring BU
mkdir /home/nol/.bitcoin/
chown -R nol.nol /home/nol/.bitcoin/

cat << EOF > /home/nol/.bitcoin/bitcoin.conf
# auth
rpcuser=whatever
rpcpassword=$(dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev)

# general setting
chain_nol=1

# logging
debug=thin

#blk
net.excessiveBlock=1000000000
net.excessiveSigopsPerMb=1000000
mining.blockSize=1000000000


# request manager
net.txRetryInterval=999000000
net.blockRetryInterval=200000000
net.thinBlockTimeout=900


# txns, mempool, fees
wallet.coinSelSearchTime=0
wallet.maxTxFee=1000
minlimitertxfee=0
maxlimitertxfee=0
limitdescendantcount=500
limitdescendantsize=2501
limitancestorcount=500
limitancestorsize=2501
# limit 0 fee relay to 1MB per minute (default 15K)
limitfreerelay=1000
# reserve 5MB for hi prio txns (default 50K)
blockprioritysize=5000000
#set max mempool size to 1GB
maxmempool=5500
# set forktime (Sept 9th, 2017 14:31:44 UTC)
mining.forkTime=1504888000

#peering
dnsseed=0

# add static node if you want
addnode=<insert ip address 1>
addnode=<insert ip address 2>
addnode=<insert ip address 3>

# increase the bloom filter size ten fold (~)
xthinbloomfiltersize=20000000

# to use once we have enough coin
net.magic=<insert your custom net magix bits here>

# net tweaks
maxsendbuffer=10000
maxreceivebuffer=50000

# make getblocktemplates works even if we spent a lot of time w/o mining
mining.unsafeGetBlockTemplate=false
EOF

chown nol:nol /home/nol/.bitcoin/bitcoin.conf
chmod go-rwx /home/nol/.bitcoin/bitcoin.conf

# Setting up systemd for BU

cat << EOF > /lib/systemd/system/bitcoind.service
[Unit]
Description=Bitcoin BU Node / bitcoind
After=network.target

[Service]
Type=forking
User=nol
ExecStart=/usr/local/bin/bitcoind -daemon
ExecStop=/usr/local/bin/bitcoin-cli stop
#PIDFile=/home/nol/.bitcoin/bitcoind.pid

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=2s
StartLimitInterval=120s
StartLimitBurst=5


[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /lib/systemd/system/bitcoind-dbg.service
[Unit]
Description=Bitcoin BU Node (DBG) / bitcoind
After=network.target

[Service]
Type=forking
User=nol
ExecStart=/usr/local/bin/bitcoind.dbg  -daemon
ExecStop=/usr/local/bin/bitcoin-cli stop
#PIDFile=/home/nol/.bitcoin/bitcoind.pid

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=2s
StartLimitInterval=120s
StartLimitBurst=5


[Install]
WantedBy=multi-user.target
EOF

# swap if needed 
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

systemctl daemon-reload
systemctl enable bitcoind
systemctl enable bitcoind-dbg
systemctl start bitcoind
