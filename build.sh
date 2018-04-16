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
    echo "Building base ${coreVersion}..."
    docker build \
        -t zokradonh/kopano_base:latest \
        -t zokradonh/kopano_base:${coreVersion} \
        --network host \
        --build-arg CORE_VERSION=${coreVersion} \
        https://github.com/ZokRadonh/KopanoDocker.git#:base

    components=(server spooler monitor ical gateway search dagent)

    # build all other components
    for repo in ${components[@]}; do
        echo "Building $repo..."
        docker build \
            -t zokradonh/kopano_${repo}:latest \
            -t zokradonh/kopano_${repo}:${coreVersion} \
            --network host \
            --build-arg BASE_VERSION=${coreVersion} \
            https://github.com/ZokRadonh/KopanoDocker.git#:$repo
    done
fi

if [ $webappVersion != 0 ]
then
    components=(webapp)

    # build all other components
    for repo in ${components[@]}; do
        echo "Building $repo..."
        docker build \
            -t zokradonh/kopano_${repo}:latest \
            -t zokradonh/kopano_${repo}:${webappVersion} \
            --network host \
            --build-arg WEBAPP_VERSION=${webappVersion} \
            https://github.com/ZokRadonh/KopanoDocker.git#:$repo
    done
fi