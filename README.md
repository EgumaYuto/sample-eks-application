# Sample Docker Application

## 起動 
```
$ ./gradlew build
$ docker build -t springio/gs-spring-boot-docker . 
$ docker run -p 8080:8080 springio/gs-spring-boot-docker
$ curl http://localhost:8080/
```