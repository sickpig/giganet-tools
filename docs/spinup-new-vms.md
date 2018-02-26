## Linode

Use Linode command line command to spin up new VMs. See: https://github.com/linode/cli  and https://github.com/linode/linode-cli for more info.

##Install the tools:

    sudo bash -c 'echo "deb http://apt.linode.com/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/linode.list'
    wget -O- https://apt.linode.com/linode.gpg | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install linode-cli

##Configure

You can configure defaults, including your API key and common deployment options, by running the configuration helper:

    linode configure

##Setting up

Setting up a stackscript

    linode stackscript list
    linode stackscript create --label "StackScript Name" --codefile "/path/myscript.sh" --distribution "Debian 7"
    linode stackscript show My-StackScript-Label
    linode stackscript source mystackscript > myscript.sh

List of location

    linode location

    singapore
    atlanta
    fremont
    frankfurt
    tokyo
    london
    newark
    dallas
    shinagawa1

How to create a new instances based on a given stackscirpt:

    linode create linode11 --location singapore  --plan "Linode 1024" --distribution "Ubuntu 16.04 LTS"  --stackscript 113903 --password "ricorda..linode" --stackscriptjson '{ "host_namme" : "linode11"}'

Get a list of all your nodes

    linode list

## Digital Ocean

See this documentation for a comprehensive list of commands https://github.com/digitalocean/doctl/blob/master/README.md

Region list

nyc1
ams2
sgp1
lon1
nyc3
fra1
tor1
sfo2
blr1

create a new VM

doctl compute droplet create your-vm-name --tag-name tag-for-grouping --enable-ipv6 --image 25237898 --region nyc1 --size 512mb --ssh-keys 5089370,7001068

## Vultr

See this doc https://github.com/JamesClonk/vultr for a complete list of available feature.

create a new VM

vultr server create -n "nameit" -r 8  -p 201 --ipv6=true -o 215 -s 72551 -k asdsadsadaxc
