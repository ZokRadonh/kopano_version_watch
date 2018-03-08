#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Please specify core and webapp version to build: ./build.sh 8.4.0.45 3.2.0.22"
    exit 1
fi

coreVersion=$1
webappVersion=$2

if [ $coreVersion != 0 ]
then
    # build base
    echo "Building kopano_base ${coreVersion}..."
    docker build \
        -t zokradonh/kopano_base:latest \
        -t zokradonh/kopano_base:${coreVersion} \
        --network host \
        https://github.com/ZokRadonh/kopano_base.git

    components=(kopano_server kopano_spooler kopano_monitor kopano_ical kopano_gateway kopano_search kopano_dagent)

    # build all other components
    for repo in ${components[@]}; do
        echo "Building $repo..."
        docker build \
            -t zokradonh/${repo}:latest \
            -t zokradonh/${repo}:${coreVersion} \
            --network host \
            --build-arg BASE_VERSION=${coreVersion} \
            https://github.com/ZokRadonh/$repo.git
    done
fi

if [ $webappVersion != 0 ]
then
    components=(kopano_webapp)

    # build all other components
    for repo in ${components[@]}; do
        echo "Building $repo..."
        docker build \
            -t zokradonh/${repo}:latest \
            -t zokradonh/${repo}:${webappVersion} \
            --network host \
            --build-arg BASE_VERSION=${coreVersion} \
            https://github.com/ZokRadonh/$repo.git
    done
fi