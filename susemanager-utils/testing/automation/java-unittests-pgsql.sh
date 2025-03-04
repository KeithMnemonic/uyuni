#! /bin/sh
SCRIPT=$(basename ${0})

TARGET="test-pr"

if [ -z ${PRODUCT+x} ];then
    VPRODUCT="VERSION.Uyuni"
else
    VPRODUCT="VERSION.${PRODUCT}"
fi

help() {
  echo ""
  echo "Script to run a docker container to run the pgsql Java unit tests"
  echo ""
  echo "Syntax: "
  echo ""
  echo "${SCRIPT} [-t ant-target] [-P PROJECT]"
  echo ""
  echo "Where: "
  echo "  -t  Ant target to run. Default: ${TARGET}"
  echo ""
}

while getopts "c:t:P:h" opts; do
  case "${opts}" in
    t) TARGET=${OPTARG};;
    P) VPRODUCT="VERSION.${OPTARG}" ;;
    h) help
       exit 0;;
    *) echo "Invalid syntax. Use ${SCRIPT} -h"
       exit 1;;
  esac
done
shift $((OPTIND-1))
HERE=`dirname $0`

if [ ! -f ${HERE}/${VPRODUCT} ];then
   echo "${VPRODUCT} does not exist"
   exit 3
fi

echo "Loading ${VPRODUCT}"
. ${HERE}/${VPRODUCT}

GITROOT=`readlink -f ${HERE}/../../../`

INITIAL_CMD="/manager/susemanager-utils/testing/automation/initial-objects.sh"
CMD="/manager/java/scripts/docker-testing-pgsql.sh ${TARGET}"
CHOWN_CMD="/manager/susemanager-utils/testing/automation/chown-objects.sh $(id -u) $(id -g)"

docker pull $REGISTRY/$PGSQL_CONTAINER
docker run --privileged --rm=true -v "$GITROOT:/manager" \
    $REGISTRY/$PGSQL_CONTAINER \
    /bin/bash -c "${INITIAL_CMD}; ${CMD}; RET=\${?}; ${CHOWN_CMD} && exit \${RET}"
