# Use the CentOS 7 base image
FROM centos:7

USER root
# Copy SSL certificate and key add configuration files
COPY server.crt /server.crt
COPY server.key /server.key
COPY server.xml /server.xml

# Copy a bash script to configure Tomcat
COPY setup.sh /setup.sh
# Run the bash script
RUN bash /setup.sh

# Expose the necessary port
EXPOSE 4041

USER tomcat
# Start Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]

