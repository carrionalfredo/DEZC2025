SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    trip_distance <= 1;

SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    (trip_distance > 1 AND trip_distance <= 3);

SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    (trip_distance > 3 AND trip_distance <= 7);

SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    (trip_distance > 7 AND trip_distance <= 10);

SELECT
    count(index)
FROM
    green_taxi_trips
WHERE
    (lpep_pickup_datetime >= '2019-10-01' AND lpep_dropoff_datetime < '2019-11-01')
    AND
    trip_distance > 10;

SELECT
    CAST(lpep_pickup_datetime AS Date) AS "day",
    trip_distance
FROM
    green_taxi_trips
ORDER BY
    trip_distance DESC
LIMIT
    1;

SELECT
*
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

SELECT
		zones."Zone",
		trips."tip_amount"
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


