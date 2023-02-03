#!/usr/bin/env bash

projectRoot=$(realpath "$(dirname "$0")")
installs=""
dependencies=("docker")

for cmd in "${dependencies[@]}" ; do command -v "$cmd" &> /dev/null || installs+="$cmd "; done

if [ -n "$installs" ]; then
    printf "Prepairing the system, please wait"
    [ -n "$(command -v yum)" ] && pcmd=yum
    [ -n "$(command -v apt-get)" ] && pcmd=apt-get
    if [ -z "$pcmd" ]; then
        printf "\nPlease install the following first: %s" "$installs"
        exit 1
    fi
    if [ "$pcmd" = "apt-get" ]; then
        if ! outUpdate=$(sudo $pcmd update 2>&1); then
            printf "\nProblem updating!"
            printf "\n Install Failure Message:\n"
            echo "${outUpdate}"
            exit 1
        fi
    fi
    printf "."

    # Some OS's will have docker under the name docker.io, having both will successfully install docker without error
    [[ "$installs" =~ "docker" && "$pcmd" = "apt-get" ]] && installs+="docker.io"
    
    if ! outInstall=$(sudo $pcmd install -y $installs 2>&1); then
        printf "\nProblem installing tools!"
        printf "\nPlease make sure the following tools are installed and run the script again: %s" "$installs"
        printf "\n Install Failure Message:\n"
        echo "${outInstall}"
        exit 1
    fi
    printf "."
    if [[ $(docker ps 2>&1) =~ "daemon running" ]]; then
        if ! outEnable=$(sudo systemctl enable docker 2>&1); then
            printf "\nProblem enabling docker!\n"
            echo "$outEnable"
            exit 1
        fi
        printf "."

        if ! outStart=$(sudo systemctl start docker 2>&1); then
            printf "\nProblem starting docker!\n"
            echo "$outStart"
            exit 1
        fi
    fi
    printf ".\n\n"
fi
if [[ ! -e /usr/bin/crawler ]]; then
    ln -s "${projectRoot}/crawler" /usr/bin/crawler
fi
if [[ ! -e /usr/bin/crawler-job ]]; then
    ln -s "${projectRoot}/crawler-job" /usr/bin/crawler-job
fi
