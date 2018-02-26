cat */bloom-filter.txt > tot_bloom-filter.txt
cat */proctime.txt     > tot_proctime.txt
cat */reass-rereq.txt  > tot_reass-rereq.txt
cat */reass.txt        > tot_reass.txt
cat */received.txt     > tot_received.txt
cat */received2.txt    > tot_received2.txt
cat */reqtime.txt      > tot_reqtime.txt

mkdir -p total
cd total
/usr/bin/file-rename 's/tot_//' *txt
