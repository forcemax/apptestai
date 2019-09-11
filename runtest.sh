#!/bin/bash

CONTAINER_NAME="$(python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)')"
ANDROID_DIR=${ANDROID_DIR:="${HOME}/.android"}

function help() {
  echo "$0 - run a device test inside Docker"
  echo
  echo "Usage: $0 -d <ANDROID_SERIAL> -f <APK_FILE>"
  echo
  echo "-d ANDROID_SERIAL is required parameter."
  echo "-f APK_FILE is required parameter."

  echo
  echo "Example: "
  echo
  echo "$0 -d 3230158fa71fc0df -f application.apk"
  echo
  exit
}


REQ_FLAG=0

while getopts "d:f:h" opt; do
  case $opt in
    d) REQ_FLAG=$((REQ_FLAG+1)); ANDROID_SERIAL=${OPTARG} ;;
    f) REQ_FLAG=$((REQ_FLAG+1)); APK_FILE=${OPTARG} ;;
    h) help ;;
    \?) echo "Invalid option: -$OPTARG" >&2 ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1; ;;
  esac
done

if [ $REQ_FLAG -ne 2 ]
then
  echo "Error : -d ANDROID_SERIAL is required parameter." >&2
  echo "Error : -f APK_FILE is required parameter." >&2
  exit 1
fi

### check android device


### create output directories
mkdir -p output/logs
mkdir -p output/screenshots

### check apk file
if [ -f $APK_FILE ]
then
  cp $APK_FILE output/application.apk
else
  echo "Error : file not exist. ${APK_FILE}"
fi

SCRIPT=${SCRIPT:="/start.sh"}
DOCKER_IMAGE=${DOCKER_IMAGE:="apptestai/apptestai-docker:latest"}
DOCKER_FLAGS=${DOCKER_FLAGS:="--privileged"}

IOD_SERVER_URL=${IOD_SERVER_URL:=""}
# dev
IOD_SERVER_URL="http://220.76.90.60:9123"
CREDENTIALS_USER="gildong4285@gmail.com"
CREDENTIALS_PASSWORD="1q2w3e4r"
SCRIPT_RUN_TIME=1800000  # 30 minutes
# SCRIPT_RUN_TIME=600000  # 10 minutes
# SCRIPT_RUN_TIME=300000  # 5 minutes

### kill host adb server
ADB_CMD="adb"
if [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
   ADB_CMD="/c/Program Files (x86)/Minimal ADB and Fastboot/adb.exe"
fi
"$ADB_CMD" kill-server

docker run --rm -it --name=${CONTAINER_NAME} ${DOCKER_FLAGS} -v maven:/root/.m2 -v ${ANDROID_DIR}:/root/.android \
  -v $(pwd)/output:/test -v /dev/bus/usb:/dev/bus/usb \
  -e ANDROID_SERIAL=${ANDROID_SERIAL} -e IOD_SERVER_URL=${IOD_SERVER_URL} -e SCRIPT_RUN_TIME=${SCRIPT_RUN_TIME} \
  -e CREDENTIALS_USER=${CREDENTIALS_USER} -e CREDENTIALS_PASSWORD=${CREDENTIALS_PASSWORD} \
  -w /test -u root ${DOCKER_IMAGE} \
  "${SCRIPT}" 2>&1 | tee output/console.log
