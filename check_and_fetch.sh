#!/bin/bash

component=$1

currentUrl=$( lynx -listonly -nonumbers -dump https://download.kopano.io/community/$component:/ | grep Debian_9.0-amd64.tar.gz )

currentFileName=$( echo "$currentUrl" | grep -o "$component-.+")
currentVersion=$( echo "$currentUrl" | grep -o "$component-[^-]+")

if [ ! -d /kopanowatch/archive/$currentVersion ]
then
    mkdir -p /kopanowatch/archive/$currentVersion
    curl -L $currentUrl > /kopanowatch/archive/$currentVersion/$currentFileName

    echo "Archived new nightly build ($currentVersion)."
fi