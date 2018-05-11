#!/bin/bash

if [ "$TRAVIS" = true ]; then
	echo "This is Travis, don't pre-install \`az\`... Exiting 0..."
	exit 0
fi

ENV_DIR="/az-python"

check_error()
{
	if [ $1 -ne 0 ]; then
		echo 'Failed to install!' >&2
		exit $1
	fi
}

virtualenv $ENV_DIR
check_error $?

. $ENV_DIR/bin/activate
check_error $?

pip install --upgrade 'wheel==0.31.0'
check_error $?
pip install --upgrade 'setuptools==39.0.1'
check_error $?
pip install --upgrade 'azure-cli==2.0.31'
check_error $?
