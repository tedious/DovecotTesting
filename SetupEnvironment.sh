#!/bin/sh

# Tired of trying to decipher whether Travis is showing me cached logs or not.
date -u


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -n "$TRAVIS" ]; then

    echo 'Starting Travis Provisioning'

    if [ ! -d "$DIR/resources" ]; then
        DIR="$( dirname $(find $TRAVIS_BUILD_DIR -name '.dovecottestingmark') )"
    fi

    sudo cp -Rp $DIR/resources /resources
    sudo /bin/bash /resources/Scripts/Provision.sh
    sudo /bin/bash /resources/Scripts/SSL.sh

else

    # Since not in travis, lets load up a system with vagrant

    echo 'Starting Vagrant Provisioning'

    cd $DIR/vagrant

    VAGRANTSTATUS=$(vagrant status)

    # If vagrant is running already, reprovision it so it has fresh email boxes.
    if echo "$VAGRANTSTATUS" | egrep -q "running" ; then
        vagrant provision
    else
        vagrant up --provision
    fi
    cd $DIR

fi

echo 'Environment has finished being setup'