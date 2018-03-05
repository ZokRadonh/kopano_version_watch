#!/bin/bash

component=$1

if [ $# -eq 0 ]
  then
    echo "Please specify component to check: ./check_and_fetch.sh core"
    exit 1
fi

architectures=$(lynx -listonly -nonumbers -dump https://download.kopano.io/community/$component:/)

currentUrl=$( echo "$architectures" | grep Debian_9.0-amd64.tar.gz )

if [ -z "$currentUrl" ]
then
    currentUrl=$( echo "$architectures" | grep Debian_9.0-all.tar.gz )
fi

currentFileName=$( echo "$currentUrl" | grep -Po "$component-.+")
currentVersion=$( echo "$currentUrl" | grep -Po "$component-[^-]+")

if [ ! -d /kopanowatch/archive/$currentVersion ]
then
    mkdir -p /kopanowatch/archive/$currentVersion
    curl -L $currentUrl > /kopanowatch/archive/$currentVersion/$currentFileName

    echo "Archived new nightly build ($currentVersion)."
fi