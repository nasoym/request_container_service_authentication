#!/usr/bin/env bash
set -ef -o pipefail

: ${PORT:="8080"}
: ${VERBOSE_OPTIONS:=""}
: ${SERVICE:="$(dirname $0)/service.sh"}
: ${SERVER_PEM_FILE:="certificate/server.pem"}

socat \
  $VERBOSE_OPTIONS \
  OPENSSL-LISTEN:${PORT},reuseaddr,fork,verify=0,cert=${SERVER_PEM_FILE} \
  EXEC:"${SERVICE}"

