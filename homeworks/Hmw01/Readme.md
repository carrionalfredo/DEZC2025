# Module 1 Homework: Docker & SQL

## Question 1. Understanding docker first run

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

What's the version of pip in the image?

**ANSWER**

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

**ANSWER**

`db:5432` and `postgres:5432`

## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:

1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles

**ANSWER**

First, is necesary to modify the python script, because the .csv file has a little different data headers.
All the operations with the columns headers ```tpep_pickup_datetime``` and ```tpep_dropoff_datetime``` must be modified with ```lpep_pickup_datetime``` and ```lpep_dropoff_datetime``` respective new headers.

After that, with the above docker compose services running, run the modified python script with the following bash command:

    python hmw_ingest_data.py \
    --user=postgres \
    --password=postgres \
    --host=localhost \
    --port=5433 \
    --db=ny_taxi \
    --table_name=green_taxi_trips \
    --url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"

Also, modify the script for load the taxi zone data into another table in ```ny_taxi``` database.

Run the script for load the zone data with the followin command:

    python hmw_ingest_zones.py \
    --user=postgres \
    --password=postgres \
    --host=localhost \
    --port=5433 \
    --db=ny_taxi \
    --table_name=taxi_zone_data \
    --url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"

Now the data for both tables is ready for query.

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

**1. Up to 1 mile**

```sql
SELECT
count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    trip_distance <= 1;
```

|count|
|-----|
|104802|

**2. In between 1 (exclusive) and 3 miles (inclusive),**

```sql
SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    (trip_distance > 1 AND trip_distance <= 3);
```

|count|
|-----|
|198924|

**3. In between 3 (exclusive) and 7 miles (inclusive),**

```sql
SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    (trip_distance > 3 AND trip_distance <= 7);
```

|count|
|-----|
|109603|

**4. In between 7 (exclusive) and 10 miles (inclusive),**

```sql
SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    (trip_distance > 7 AND trip_distance <= 10);
```

|count|
|-----|
|27678|

**5. Over 10 miles**

```sql
SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    trip_distance > 10;
```

|count|
|-----|
|35189|

## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

**ANSWER**

```sql
SELECT
    lpep_pickup_datetime,
    trip_distance
FROM
    green_taxi_trips
ORDER BY
    trip_distance DESC
LIMIT
    1;
```

|day|trip_distance|
|---|-------------|
|2019-10-31| 518.89|

## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in ```total_amount``` (across all trips) for 2019-10-18?

Consider only ```lpep_pickup_datetime``` when filtering by date.

**ANSWER**

```sql
SELECT
Zone
FROM
    (SELECT
        zones."Zone",
		sum(trips."total_amount") as "total"
    FROM
        green_taxi_trips AS trips
	JOIN
		taxi_zone_data AS zones
	ON trips."PULocationID" = zones."LocationID"
    WHERE
        CAST(lpep_pickup_datetime AS DATE) = '2019-10-18'
	GROUP BY
	zones."Zone"
	ORDER BY
	"total" DESC)
WHERE "total" > 13000
ORDER BY
"total" DESC;
```

|Zone|
|----|
|East Harlem North|
|East Harlem South|
|Morningside Heights|

## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone named "East Harlem North" which was the drop off zone that had the largest tip?

Note: it's tip , not trip

We need the name of the zone, not the ID.

**ANSWER**

```sql
SELECT
		zones."Zone"
	FROM
		green_taxi_trips AS "trips"
	JOIN
		taxi_zone_data AS zones
	ON
		trips."DOLocationID" = zones."LocationID"
	WHERE
		trips."PULocationID" = (SELECT
									zones."LocationID"
									FROM
									taxi_zone_data AS "zones"
									WHERE
									zones."Zone" = 'East Harlem North')
	ORDER BY
		trips."tip_amount" DESC
	LIMIT
		1;
```

|Zone|
|----|
|JFK Airport|
