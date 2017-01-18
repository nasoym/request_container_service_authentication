#!/usr/bin/env bash

set -f -o pipefail

source lib/logger
source lib/authorization
source lib/http_helpers
source lib/parse_request

: ${FORWARD_ADDRESS:="localhost:8080"}

parse_request

  log "request: ${SOCAT_PEERADDR}:${SOCAT_PEERPORT} ${request_method} ${request_uri}"

authorization="$(get_header_value "authorization" <<<"$request_header_lines")"
echo "got authorization: >$authorization" >&2
authorization_verify "$authorization"

echo -e "${request_method} ${request_uri} ${request_http_version}\n${request_header_lines}${request_content}" \
    | socat -t 10 - TCP:${FORWARD_ADDRESS},shut-none

