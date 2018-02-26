basically this suppose to have the `debug.log` for any given node of the network, stored in a separate directory, one for each node
`pre-process.sh` will extract a bunch of info from `debug.log`

    bloom-filter.txt
    proctime.txt
    reass-rereq.txt
    reass.txt
    received.txt
    received2.txt
    reqtime.txt

then `pre-process-total.sh` put every single file together with all other for the same type
e.g `cat node1/proctime.txt node2/proctime.txt .... > tot_proctime.txt`
the `total.sql` will import the data in a postgresql and join all the data together and produce something like
