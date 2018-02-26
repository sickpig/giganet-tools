## Giganet Test Initiative: tools and docs collection

This repo is a collections of scripts to set up, manage, maintain, gather data from the Gigablock Test Inititative Network.

### Repository structure

Repo contains 3 main folders:

- scripts (moslty shell script to instantiate and upate VMs, but also fetch info from log and monitoring).
- data (example data set especially as a result of gathering data from log files)
- docs (basically very short how to for various functions)

#### Scripts

- parse-tcpflow.py
- prop-time-01-pre-process.sh
- prop-time-02-pre-process-total.sh
- prop-time-03-total.sql
- setup-nodes.sh
- txramp.py
- update-nodes.sh

#### Data

- prop-time-xthin.csv

#### Docs

- setup-building-enviroment.md
- describe-bitcoin-conf-par.md
- setup-gitian-determinisc-build-env.md
- parse-log-for-block-propagation.md
- spinup-new-vms.md
- setup-new-nodes.md
- tcpflows-data-parsing.md
- tnxs-generator-script.md


