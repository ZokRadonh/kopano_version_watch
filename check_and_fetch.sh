#!/bin/bash

requireBuild=0

check_and_archive() {
    component=$1

    if [ $# -eq 0 ]
    then
        echo "Please specify component to check: check_and_archive core|webapp"
        exit 1
    fi

    #architectures=$(curl -sL https://download.kopano.io/community/${component}: |  grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' |  sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//')
    architectures=$(lynx -listonly -nonumbers -dump https://download.kopano.io/community/$component:)

    currentUrl=$( echo "$architectures" | grep Debian_9.0-amd64.tar.gz )

    if [ -z "$currentUrl" ]
    then
        currentUrl=$( echo "$architectures" | grep Debian_9.0-all.tar.gz )
    fi

    if [ -z "$currentUrl" ]
    then
        echo "Unable to find matching distribution (Debian_9.0)."
        exit 1
    fi

    currentFileName=$( echo "$currentUrl" | sed -r -e "s#.*/(.*)#\1#")
    currentVersion=$( echo "$currentUrl" | sed -r -e "s#.*($component-[0-9.]*).*#\1#")
    currentVersionPretty=$( echo "$currentUrl" | sed -r -e "s#.*$component-([0-9.]*).*#\1#")

    cd /kopanowatch/archive/

    if [ ! -d /kopanowatch/archive/$currentVersion ]
    then
        mkdir -p /kopanowatch/archive/$currentVersion
        # download new version
        curl -sL $currentUrl > /kopanowatch/archive/$currentVersion/$currentFileName
        # extract
        tar -x -z -f /kopanowatch/archive/$currentVersion/$currentFileName --strip-components 1 -C /kopanowatch/archive/$currentVersion/
        rm /kopanowatch/archive/$currentVersion/$currentFileName
        # prepare index file
        rm -f /kopanowatch/archive/Packages.gz
        # parse and add to index
        apt-ftparchive -d=/kopanowatch/archive/cache packages . > /kopanowatch/archive/Packages
        # finalize index
        gzip -9 /kopanowatch/archive/Packages

        echo "Archived new nightly build ($currentVersion)."
        requireBuild=1
    fi
}
coreVersion=0
webappVersion=0

check_and_archive core
if [ $requireBuild -eq 1 ]
then
    coreVersion=$currentVersionPretty
    requireBuild=0
fi

check_and_archive webapp
if [ $requireBuild -eq 1 ]
then
    webappVersion=$currentVersionPretty
    requireBuild=0
fi

/kopanowatch/build.sh $coreVersion $webappVersion