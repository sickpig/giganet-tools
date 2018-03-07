## How to produce deterministic build

Proviso: these instructions has bee tested and validated on ubuntu 16.04 amd64.

### Command line set of commands:

    # clone the repo containin the tools to produce the binaries
    git clone git@github.com:devrandom/gitian-builder.git

    # install system requirments
    sudo apt-get install git apache2 apt-cacher-ng python-vm-builder ruby qemu-utils

    # chaneg dir into your cloned tool repo
    cd gitian-builder

    # set up the base image that we are going to use to spin up the VM where the binaries
    # will be actually compiled. This step is una tantum
    bin/make-base-vm --arch amd64 --suite trusty

    # this aux need to be create
    mkdir inputs

    # actually build the binaries
    ./bin/gbuild --url bitcoin=https://github.com/sickpig/BitcoinUnlimited --commit bitcoin=fix-net-magic-cash gitian-descriptor.yml

Once the process will end you'll be able to find the bianries in:

    ./build/out

### Hacks work around and further specification

First `python-vm-builder` need to be manually patched using the patch you find here:

    https://bugs.launchpad.net/ubuntu/+source/vm-builder/+bug/1618899/comments/2

w/o the patch `bin/make-base-vm --arch amd64 --suite trusty` will fail.

Second you need to customize `--url bitcoin=` and `--commit bitcoin=` command line parameters to reflect the repository you want to use and which branch/commit/tag you want to use. E.g.

    ./bin/gbuild --url bitcoin=https://github.com/sickpig/BitcoinUnlimited --commit bitcoin=giga_perf gitian-descriptor.yml

Lastly the last parameter of the above command line `gitian-descriptor.yml` is the recipe that the process use to build the binaries. It determines the target architecture (arm, amd64 etc etc), if you build also QT etc etc. The default gitian descriptors could be found in the BU repo under `contrib/gitian-descriptors`.

To make the build process I modified the default linux descriptor so that it won't build QT, all binaries needed for unit testing and it will build just for x86_84 and not for i386. Yo u would find this in this repo under [scripts/gitian-linux-slim-bucash.yml] folder.


