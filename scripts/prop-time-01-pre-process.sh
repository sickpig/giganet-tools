#!/bin/bash

export DATE=$1
export HOST=$2

grep $DATE $HOST/debug.log > mempool-limited-$DATE-$HOST.log
grep "Reassembled xthinblock" $HOST/mempool-limited-20-oct-17.log | awk '{print $1, $2, $6, $7, $11, $15, $16, $17}' > $HOST/reass.txt
sed  --in-place -e 's/(//g' $HOST/reass.txt
sed  --in-place -e 's/)//g' $HOST/reass.txt
sed  --in-place -e 's/,//g' $HOST/reass.txt
sed  --in-place -e 's/peer=//g'  $HOST/reass.txt
sed  --in-place -e 's/^/$DATE /' $HOST/reass.txt
sed  --in-place -e '1s/^/node day time hash blksize xthinsize compression ip_port peerid\n/' $HOST/reass.txt
grep "Reassembled xblocktx" $HOST/mempool-limited-20-oct-17.log | awk '{print   $1, $2, $6, $7, $11, $21, $22, $23, $15}' > $HOST/reass-rereq.txt
sed  --in-place -e 's/(//g' $HOST/reass-rereq.txt
sed  --in-place -e 's/)//g' $HOST/reass-rereq.txt
sed  --in-place -e 's/,//g' $HOST/reass-rereq.txt
sed  --in-place -e 's/peer=//g'  $HOST/reass-rereq.txt
sed  --in-place -e 's/^/$DATE /' $HOST/reass-rereq.txt
sed  --in-place -e '1s/^/node day time hash blksize xthinsize compression ip_port peerid txsize \n/' $HOST/reass-rereq.txt
grep "Created bloom filter"   $HOST/mempool-limited-20-oct-17.log | awk '{print $1, $2, $6, $10, $11}' > $HOST/bloom-filter.txt
sed  --in-place -e 's/in://g' $HOST/bloom-filter.txt
sed  --in-place -e 's/^/$DATE /' $HOST/bloom-filter.txt
sed  --in-place -e '1s/^/node day time size hash ms\n/' $HOST/bloom-filter.txt
grep "Received xthinblock" $HOST/mempool-limited-20-oct-17.log | awk '{print $1, $2, $5, $8, $9, $11}' > $HOST/received.txt
sed  --in-place -e 's/(//g' $HOST/received.txt
sed  --in-place -e 's/)\.//g' $HOST/received.txt
sed  --in-place -e 's/^/$DATE /' $HOST/received.txt
sed  --in-place -e '1s/^/node day time hash ip_port peerid xthinsize\n/' $HOST/received.txt
grep "Received block" mempool-limited-20-oct-17.log | awk '{print $1, $2, $5, $7}' > $HOST/received2.txt
sed  --in-place -e 's/^/$DATE /' $HOST/received2.txt
sed  --in-place -e '1s/^/node day time hash rectime\n/' $HOST/received2.txt
grep "Processed Block " mempool-limited-20-oct-17.log | awk '{print $1, $2, $5, $8, $10, $12, $13}'> $HOST/proctime.txt
sed  --in-place -e 's/(//g' $HOST/proctime.txt
sed  --in-place -e 's/)//g' $HOST/proctime.txt
sed  --in-place -e 's/peer=//g'  $HOST/proctime.txt
sed  --in-place -e 's/^/$DATE /' $HOST/proctime.txt
sed  --in-place -e '1s/^/node day time hash blktype proctime ip_port peerid\n/' proctime.txt
grep "Requesting xthinblock" mempool-limited-20-oct-17.log | awk '{print $1, $2, $5, $8, $9}' > $HOST/reqtime.txt
sed  --in-place -e 's/(//g' $HOST/reqtime.txt
sed  --in-place -e 's/)//g' $HOST/reqtime.txt
sed  --in-place -e 's/^/$DATE /' $HOST/reqtime.txt
sed  --in-place -e '1s/^/node day time hash ip_port peerid\n/' $HOST/reqtime.txt

sed -i '/already block/d' $HOST/received.txt
