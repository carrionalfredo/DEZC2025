# Module 1 Homework: Docker & SQL

## Question 1. Understanding docker first run

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

What's the version of pip in the image?

### **ANSWER**

    docker run -it python:3.12.8
    Unable to find image 'python:3.12.8' locally
    3.12.8: Pulling from library/python
    eb52a57aa542: Download complete
    bf571be90f05: Download complete
    5f16749b32ba: Download complete
    fbf93b646d6b: Download complete
    e00350058e07: Download complete
    684a51896c82: Download complete
    fd0410a2d1ae: Download complete
    Digest: sha256:9cdef3d6a7d669fd9349598c2fc29f5d92da64ee76723c55184ed0c8605782cc
    Status: Downloaded newer image for python:3.12.8


    root@4478581962d2:/# pip --version
    pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)

## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that pgadmin should use to connect to the **postgres** database?

```yaml
    services:
    db:
        container_name: postgres
        image: postgres:17-alpine
        environment:
        POSTGRES_USER: 'postgres'
        POSTGRES_PASSWORD: 'postgres'
        POSTGRES_DB: 'ny_taxi'
        ports:
        - '5433:5432'
        volumes:
        - vol-pgdata:/var/lib/postgresql/data

    pgadmin:
        container_name: pgadmin
        image: dpage/pgadmin4:latest
        environment:
        PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
        PGADMIN_DEFAULT_PASSWORD: "pgadmin"
        ports:
        - "8080:80"
        volumes:
        - vol-pgadmin_data:/var/lib/pgadmin  

    volumes:
    vol-pgdata:
        name: vol-pgdata
    vol-pgadmin_data:
        name: vol-pgadmin_data
```

### **ANSWER**

`db:5432` and `postgres:5432`

## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:

1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles

### **ANSWER**
