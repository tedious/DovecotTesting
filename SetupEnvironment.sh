#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -n "$TRAVIS" ]; then

    echo 'Travis config not yet written'

    if [ -d "$DIR" ]; then
        DIR="$( dirname $(find ./ -name 'SetupEnvironment.sh') )"
    fi

    sudo cp -Rp $DIR/resources /resources
    sudo /bin/bash /resources/Scripts/Provision.sh
    sudo /bin/bash /resources/Scripts/SSL.sh

else

    # Since not in travis, lets load up a system with vagrant

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