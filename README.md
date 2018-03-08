# Wirecloud with NGSI proxy
This repository adds the NGSI proxy to [Wirecloud Docker image](https://hub.docker.com/r/fiware/wirecloud/) in order to allow widgets to comunicate to the backend avoiding aditional logins.

Build docker container
```
sudo docker build -t wirecloud_proxy .
```
Launch Wirecloud container
```
sudo docker run -d -p 80:80 -p 3000:3000 --name wirecloud wirecloud_proxy
```
Launch without building
```
sudo docker run -d -p 80:80 -p 3000:3000 --name wirecloud gradiant/wirecloud
```