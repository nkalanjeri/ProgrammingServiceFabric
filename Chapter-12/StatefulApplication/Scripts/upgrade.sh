#!/bin/bash -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
appPkgPath="$DIR/../StatefulApplicationApplication"
if [[ "$#" != "0" ]];then 
	version="$1"
else 
	version="1.0.0"
fi
sfctl application upload --path $appPkgPath
if [ $? -ne 0 ]; then
    echo "Application copy failed."
    exit 1
fi
sfctl application provision --application-type-build-path StatefulApplicationApplication 
if [ $? -ne 0 ]; then
    echo "Application type registration failed."
    exit 1
fi
sfctl application upgrade --app-id StatefulApplicationApplication --app-version ${version} --parameters "" --mode "Monitored"
if [ $? -ne 0 ]; then
    echo "Upgrade of application failed."
    exit 1
fi
echo "Upgrade script executed successfully."
