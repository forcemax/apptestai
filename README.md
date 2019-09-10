Apptest.ai Console Tool
=============
Apptest.ai Console Tool은 간단한 방법으로 자신의 PC에서 자신의 Android 장비를 사용하여 Apptest.ai Test를 수행할 수 있는 도구입니다.


Installation
------------
1. Install [Docker](https://www.docker.com/)
2. Pull the Docker image : ```docker pull apptestai/apptestai-docker```
3. Download runtest.sh script : ```wget https://github.com/forcemax/apptestai/runtest.sh```

Windows/Mac은 자신의 Android 장비를 사용하기 위하여 [Docker Desktop](https://www.docker.com/products/docker-desktop)이 아닌 [Docker Toolbox](https://docs.docker.com/toolbox/)를 사용해야하며, 이를 위한 문서는 다음에서 확인할 수 있습니다.


Usage
-----
**Pre-Requisites:** You must have a running zookeeper instance in order to start any of the storm daemons. 
```
docker run -p 2181:2181 -p 2888:2888 -p 3888:3888 -h zookeeper –-name="zookeeper" -d jplock/zookeeper
```

The image contains an **ENTRYPOINT** for running one container per storm daemon as follow:
  
```docker run [OPTIONS] --link zookeeper:zk -d forcemax/docker-storm --daemon (nimbus, drpc, supevisor, ui, logviewer)```  

For instance to run Nimbus or supervisor or ui:

```
## run storm nimbus (same machine with zookeeper)
docker run --name=storm-nimbus -h nimbus \
           --expose 6627 --expose 3772 --expose 3773 \
           -p 6627:6627 -p 3772:3772 -p 3773:3773 \
           --link zookeeper:zk \
           -d forcemax/docker-storm --daemon nimbus
           
## run storm supervisor (same machine with zookeeper)
docker run --name=storm-supervisor -h supervisor \
           --expose 6700 --expose 6701 --expose 6702 --expose 6703 --expose 8000 \
           -p 6700:6700 -p 6701:6701 -p 6702:6702 -p 6703:6703 -p 8000:8000 \
           --link storm-nimbus:nimbus --link zookeeper:zk \
           -d forcemax/docker-storm --daemon supervisor logviewer

## run storm ui (same machine with zookeeper)
docker run --name storm-ui -h ui \
           --expose 8080 \
           -p 8080:8080 \
           --link storm-nimbus:nimbus \
           --link zookeeper:zk \
           -d forcemax/docker-storm --daemon ui
```
Docker Compose
---
**Pre-Requisites:** [Install Compose](https://docs.docker.com/compose/#installation-and-set-up)

[Compose](https://docs.docker.com/compose/) is a tool for defining and running complex applications with Docker.
  
  - To start cluster:
	 
    **zookeeper:** ```docker-compose -p storm -f ./docker-zookeeper.yml up``` (pass the -d flag to run container in background)

    **storm:** ```docker-compose -p storm -f ./docker-storm.yml up``` (pass the -d flag to run container in background)

  - To stop cluster:

    **zookeeper:** ```docker-compose -p storm -f ./docker-zookeeper.yml stop```

    **storm:** ```docker-compose -p storm -f ./docker-storm.yml stop```

Makefiles
---------
Or you can checkout this minimal **[Makefile](https://github.com/forcemax/docker-storm/blob/master/Makefile)** for directly building and deploying storm.

To rebuild the **forcemax/docker-storm** image just run :

  - ```make storm-build```

Run the following commands to deploy/destroy your cluster.

  - ```make deploy-cluster```
  - ```make destroy-cluster```


How to submit a topology 
------------------------
Without storm installed on your machine (same machine with nimbus):

```
docker run --rm -v <HOST_TOPOLOGY_TARGET_DIR>:/home/storm/jar \
       forcemax/docker-storm \
       -c nimbus.host=`docker inspect --format='{{.NetworkSettings.IPAddress}}' storm-nimbus` \
       jar /home/storm/jar/<TOPOLOGY_JAR> <TOPOLOGY_ARGS>


```

Port binding 
-------------

Storm UI/Logviewer container ports are exposed to the host system : 

  - Storm UI : [http://localhost:8080/](http://localhost:8080/)
  - Logviewer : [http://localhost:8000/](http://localhost:8000/)


Troubleshooting
---------------
If for some reasons you need to debug a container you can use docker exec command: 

Example : ```docker exec -it storm_nimbus_1 /bin/bash```
