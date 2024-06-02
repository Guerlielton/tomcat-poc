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
    log "Install necessary packages"
    yum install -y epel-release
    yum install -y java-1.8.0-openjdk-devel wget openssl
    yum clean all && \
    rm -rf /var/cache/yum
    # ====================================================================================================

    # ====================================================================================================
    log "Set environment variables for Tomcat and add Tomcat version"

    export TOMCAT_VERSION=8.5.100
    CATALINA_HOME=${CATALINA_HOME:-/usr/local/tomcat}  # Use default if not set
    export CATALINA_HOME

    log "Set environment variables for Tomcat (CATALINA_HOME: $CATALINA_HOME)"
    ln -s $CATALINA_HOME/bin /usr/local/bin  # Optional: Create symbolic link
    mkdir -p $CATALINA_HOME/conf
    # ====================================================================================================

    # ====================================================================================================
    log "Download and extract Tomcat 8.5"
    wget https://downloads.apache.org/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz --no-check-certificate && \
    tar -zxvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /usr/local/tomcat --strip-components=1
    rm -f apache-tomcat-${TOMCAT_VERSION}.tar.gz    
    # ====================================================================================================

    log "Verify the Tomcat installation"
    if [ ! -f "$CATALINA_HOME/bin/catalina.sh" ]; then
      echo "Tomcat installation failed: $CATALINA_HOME/bin/catalina.sh not found"
      ls -l $CATALINA_HOME
      ls -l $CATALINA_HOME/bin
      exit 1
    fi
    # ====================================================================================================
 
    # ====================================================================================================
    log "Download the sample web app WAR file"
    wget https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war --no-check-certificate -P $CATALINA_HOME/webapps/
    # ====================================================================================================

    # ====================================================================================================
    log "Copy SSL certificates and server.xml"
    cp /server.crt $CATALINA_HOME/conf/
    cp /server.key $CATALINA_HOME/conf/
    cp /server.xml $CATALINA_HOME/conf/server.xml
    # ====================================================================================================

    # ====================================================================================================
    log "Create PKCS12 keystore from certificate and key"
    openssl pkcs12 -export -in $CATALINA_HOME/conf/server.crt -inkey $CATALINA_HOME/conf/server.key -out $CATALINA_HOME/conf/server.p12 -name tomcat -password pass:eka#qXW9^sQJRr
    # ====================================================================================================
    log "Create a new tomcat user and set permissions"
    useradd -m -d /usr/local/tomcat -r -s /bin/bash tomcat
    chown -R tomcat:tomcat $CATALINA_HOME
    chmod +x $CATALINA_HOME/bin/*.sh
    # ====================================================================================================
    log "Setup completed."
    # ==================================================================================================== 
}
# Execute the main function
main "$@"
