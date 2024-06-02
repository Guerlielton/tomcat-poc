#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Function to log messages
function log() {
    local diff half before after
    diff=$((100-$(echo -n "$1" | iconv -f utf8 -t ascii//TRANSLIT | wc -m)))
    half=$((diff/2))
    before=$(awk -v count=$half 'BEGIN { while (i++ < count) printf " " }')
    after=$(awk -v count=$((half+diff-(half*2))) 'BEGIN { while (i++ < count) printf " " }')
    printf "\x1b[%sm%s%s%s\x1b[0m\n" "0;30;44" "$before" "$1" "$after"
}

function main() {
    # ====================================================================================================
    log "Build Docker"
    docker build -t tomcat-sample-app .
    # ====================================================================================================
    
    # ====================================================================================================
    log "Start Docker Application"
    docker run -d -p 4041:4041 --name tomcat-sample-app tomcat-sample-app
    # ====================================================================================================
}

main "$@"