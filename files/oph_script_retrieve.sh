#!/bin/bash

# Parameters:
# URL of file
# token

# Example:
# ./retrieve.sh https://localhost/file.nc.tar.gz token 

if [ $# -ne 2 ]
then
	exit 1
fi

URL=${1}
TOKEN=${2}

# Const
DESTINATION=$OPH_SCRIPT_DATA_PATH
FILENAME=${URL##*/}

cd $DESTINATION
curl -k -d "token=$TOKEN" $URL -o "$FILENAME" > /dev/null 2>&1
if [ $? -ne 0 ]
then
	exit 2
fi

FULLPATH=`tar -xzvf $FILENAME`
if [ $? -ne 0 ]
then
	exit 3
fi

rm -f $FILENAME

echo "${DESTINATION:${#OPH_SCRIPT_DATA_PATH}}/$FULLPATH"
exit 0
