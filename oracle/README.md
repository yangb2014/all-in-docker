# Oracle Database   
https://github.com/oracle/docker-images/   
https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance/   
   
## Building Oracle Database Docker Install Images   
> [oracle@localhost dockerfiles]$ ./buildDockerImage.sh -h   
>    
> Usage: buildDockerImage.sh -v [version] [-e | -s | -x] [-i] [-o] [Docker build option]   
> Builds a Docker Image for Oracle Database.   
>    
> Parameters:   
>    -v: version to build   
>        Choose one of: 11.2.0.2  12.1.0.2  12.2.0.1  18.3.0  18.4.0  19.3.0   
>    -e: creates image based on 'Enterprise Edition'   
>    -s: creates image based on 'Standard Edition 2'   
>    -x: creates image based on 'Express Edition'   
>    -i: ignores the MD5 checksums   
>    -o: passes on Docker build option   
>    
> * select one edition only: -e, -s, or -x   
>    
> LICENSE UPL 1.0   
>    
> Copyright (c) 2014-2019 Oracle and/or its affiliates. All rights reserved.   
   
## Running Oracle Database in a Docker container   
> docker run --name <container name> \   
> -p <host port>:1521 -p <host port>:5500 \   
> -e ORACLE_SID=<your SID> \   
> -e ORACLE_PDB=<your PDB name> \   
> -e ORACLE_PWD=<your database passwords> \   
> -e ORACLE_CHARACTERSET=<your character set> \   
> -v [<host mount point>:]/opt/oracle/oradata \   
> oracle/database:19.3.0-ee   
>    
> Parameters:   
>    --name:        The name of the container (default: auto generated)   
>    -p:            The port mapping of the host port to the container port.    
>                   Two ports are exposed: 1521 (Oracle Listener), 5500 (OEM Express)   
>    -e ORACLE_SID: The Oracle Database SID that should be used (default: ORCLCDB)   
>    -e ORACLE_PDB: The Oracle Database PDB name that should be used (default: ORCLPDB1)   
>    -e ORACLE_PWD: The Oracle Database SYS, SYSTEM and PDB_ADMIN password (default: auto generated)   
>    -e ORACLE_CHARACTERSET:   
>                   The character set to use when creating the database (default: AL32UTF8)   
>    -v /opt/oracle/oradata   
>                   The data volume to use for the database.   
>                   Has to be writable by the Unix "oracle" (uid: 54321) user inside the container!   
>                   If omitted the database will not be persisted over container recreation.   
>    -v /opt/oracle/scripts/startup | /docker-entrypoint-initdb.d/startup   
>                   Optional: A volume with custom scripts to be run after database startup.   
>                   For further details see the "Running scripts after setup and on startup" section below.   
>    -v /opt/oracle/scripts/setup | /docker-entrypoint-initdb.d/setup   
>                   Optional: A volume with custom scripts to be run after database setup.   
>                   For further details see the "Running scripts after setup and on startup" section below.   
   
## Changing the admin accounts passwords   
> docker exec <container name> ./setPassword.sh <your password>   
   
## 11.2.0.2 sample   
    docker build --rm -t oracle/database:11.2.0.2-xe -f Dockerfile.xe .    
    docker run -d --shm-size=1g -p 1521:1521 -p 8080:8080 --name oracle11g oracle/database:11.2.0.2-xe    
    docker exec 74e414cae07c ./setPassword.sh 123456    
    sqlplus sys/123456@172.17.0.2/xe as sysdba    
   
## 12.1.0.2 sample   
    docker build --rm -t oracle/database:12.1.0.2-ee -f Dockerfile.ee .    
    docker run -d -p 1521:1521 -p 8080:8080 -e ORACLE_SID=orcl --name oracle12g oracle/database:12.1.0.2-ee   
