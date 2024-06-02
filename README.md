# Poc Dockerized Tomcat Sample App with SSL/TLS

## Requirements 
1. Docker installed 
2. Create a Self-Signed SSL
3. Have a server.xml template

## How to Create Self-Signed SSL
1. Execute this command in your application path to create a self-signed SSL
    ```bash
    openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -days 365 -out server.crt
After creating the self-signed SSL, we can run a docker to build and launch the sample application by following these commands  

## How to Build and Run
we can follow one of the steps below to build and run the sample app.
1. Build the Docker image:

   ```bash
   docker build -t tomcat-sample-app .
2. Run a docker image
    ```bash
    docker run -d -p 4041:4041 --name tomcat-sample-app tomcat-sample-app
3. Give the right permissions to run script and run the script.
    ```bash
    chmod +x start_docker.sh && ./start_docker.sh

# How to access 
After following the steps above, we can access the application using this path on the browser: https://localhost:4041/sample/