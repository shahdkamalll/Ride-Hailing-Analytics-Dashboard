use indrive
select * from trips
select * from drivers
select * from passengers


select area,city,count(*) as total_passengers
from passengers
group by city , area
order by total_passengers desc

SELECT preferred_payment, COUNT(*) AS total_passengers
FROM passengers
GROUP BY preferred_payment
ORDER BY total_passengers DESC

SELECT 
    area,
    COUNT(*) AS total,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS area_rank
FROM passengers
GROUP BY area

SELECT 
    acquisition_channel,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM passengers
GROUP BY acquisition_channel


select* from drivers

SELECT vehicle_type, COUNT(*) AS total_drivers
FROM drivers
GROUP BY vehicle_type
ORDER BY total_drivers DESC

SELECT 
    MONTH(registration_date) AS month,
    COUNT(*) AS new_drivers
FROM drivers
GROUP BY MONTH(registration_date)
ORDER BY month

select * from trips

select  count(*) from trips

SELECT 
    trip_id,
    COUNT(*) AS total
FROM trips
GROUP BY trip_id
HAVING COUNT(*) > 1

select trip_status, count(*)
from trips
group by trip_status
order by count(*) desc

ALTER TABLE trips
ADD fare_difference AS (driver_offered_fare - suggested_fare)

select * from trips

SELECT *
FROM trips
WHERE trip_status = 'Cancelled by Passenger'
AND fare_difference > 0
ORDER BY fare_difference DESC

select count(*) from trips
where fare_difference > 0

select count(*) from trips
where fare_difference = 0

select vehicle_type,count(*) from trips as trips_vehicle
group by vehicle_type



select vehicle_type,count(*) from trips as trips_vehicle
group by vehicle_type

SELECT 
    MONTH(trip_date) AS month,
    COUNT(*) AS total_trips
FROM trips
GROUP BY MONTH(trip_date) 
ORDER BY month 


SELECT 
    DATEPART(HOUR, trip_time) AS hour,
    COUNT(*) AS total_trips
FROM trips
GROUP BY DATEPART(HOUR, trip_time)
ORDER BY count(*) desc

SELECT 
    DATEPART(HOUR, trip_time) AS hour,
    COUNT(*) AS total_trips
FROM trips
GROUP BY DATEPART(HOUR, trip_time)
ORDER BY hour

SELECT 
    t.driver_id,
    COUNT(*) AS total_trips,
    ROUND(AVG(passenger_rating), 2) AS avg_rating
FROM trips t
JOIN drivers d ON t.driver_id = d.driver_id
GROUP BY t.driver_id
ORDER BY total_trips DESC

SELECT driver_id, COUNT(*) AS total_trips
FROM trips
WHERE trip_status = 'Completed'
GROUP BY driver_id
ORDER BY total_trips DESC

SELECT 
    t.driver_id,
    SUM(CASE WHEN t.trip_status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    SUM(CASE WHEN t.trip_status = 'Cancelled by Driver' THEN 1 ELSE 0 END) AS cancelled_by_driver,
    SUM(CASE WHEN t.trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) AS cancelled_by_passenger
FROM trips t
GROUP BY t.driver_id
ORDER BY completed_trips DESC

create table driver_performance
SELECT 
    t.driver_id,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN t.trip_status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    SUM(CASE WHEN t.trip_status = 'Cancelled by Driver' THEN 1 ELSE 0 END) AS cancelled_by_driver,
    SUM(CASE WHEN t.trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) AS cancelled_by_passenger,
    ROUND(SUM(CASE WHEN t.trip_status = 'Cancelled by Driver' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS driver_cancel_rate
FROM trips t
GROUP BY t.driver_id
ORDER BY driver_cancel_rate DESC

select* from  trips
select * from drivers


SELECT 
    t.driver_id,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN t.trip_status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    SUM(CASE WHEN t.trip_status = 'Cancelled by Driver' THEN 1 ELSE 0 END) AS cancelled_by_driver,
    SUM(CASE WHEN t.trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) AS cancelled_by_passenger,
    ROUND(SUM(CASE WHEN t.trip_status = 'Cancelled by Driver' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS driver_cancel_rate
FROM trips t
GROUP BY t.driver_id
ORDER BY completed_trips DESC

select * from driver_performance
order by driver_cancel_rate DESC

select driver_id  , driver_cancel_rate
from driver_performance
where driver_cancel_rate =0

select driver_id  , driver_cancel_rate
from driver_performance
where driver_cancel_rate >10 and driver_cancel_rate < 40



select* from trips

SELECT 
    p.passenger_id,
    p.churn_date,
    MIN(t.trip_date) AS first_trip_date,
    MIN(t.trip_status) AS first_trip_status
FROM passengers p
JOIN trips t ON p.passenger_id = t.passenger_id
GROUP BY p.passenger_id,  p.churn_date


SELECT 
    p.passenger_id,
    p.churn_date,
    t.trip_status AS first_trip_status
FROM passengers p
JOIN trips t ON p.passenger_id = t.passenger_id
WHERE t.trip_date = (
    SELECT MIN(trip_date) 
    FROM trips 
    WHERE passenger_id = p.passenger_id
)
GROUP BY p.passenger_id, p.churn_date, t.trip_status


SELECT 
    p.passenger_id,
    p.churn_date,
    t.trip_status AS first_trip_status,
    t.driver_id
FROM passengers p
JOIN trips t ON p.passenger_id = t.passenger_id
WHERE t.trip_date = (
    SELECT MIN(trip_date) 
    FROM trips 
    WHERE passenger_id = p.passenger_id
)
GROUP BY p.passenger_id, p.churn_date, t.trip_status, t.driver_id




select*from trips
select*from passengers
select*from drivers

SELECT 
    trip_status,
    driver_id,
    fare_difference,
    suggested_fare,
    driver_offered_fare
FROM trips
where fare_difference > 0

ORDER BY fare_difference DESC

SELECT 
    trip_status,
    ROUND(AVG(fare_difference), 2) AS avg_fare_difference,
    COUNT(*) AS total
FROM trips
GROUP BY trip_status
ORDER BY avg_fare_difference DESC

SELECT 
    CASE 
        WHEN fare_difference <= 5 THEN '0-5'
        WHEN fare_difference <= 10 THEN '6-10'
        WHEN fare_difference <= 20 THEN '11-20'
        ELSE 'Above 20'
    END AS fare_diff_range,
    COUNT(*) AS total,
    COUNT(CASE WHEN trip_status = 'Cancelled by Passenger' THEN 1 END) AS cancelled
FROM trips
WHERE fare_difference > 0
GROUP BY 
    CASE 
        WHEN fare_difference <= 5 THEN '0-5'
        WHEN fare_difference <= 10 THEN '6-10'
        WHEN fare_difference <= 20 THEN '11-20'
        ELSE 'Above 20'
    END
ORDER BY fare_diff_range


SELECT 
    CASE 
        WHEN fare_difference <= 5 THEN '0-5'
        WHEN fare_difference <= 10 THEN '6-10'
        WHEN fare_difference <= 20 THEN '11-20'
        ELSE 'Above 20'
    END AS fare_diff_range,
    COUNT(*) AS total,
    SUM(CASE WHEN trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) AS cancelled,
    ROUND(SUM(CASE WHEN trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS cancel_rate
FROM trips
WHERE fare_difference > 0
GROUP BY 
    CASE 
        WHEN fare_difference <= 5 THEN '0-5'
        WHEN fare_difference <= 10 THEN '6-10'
        WHEN fare_difference <= 20 THEN '11-20'
        ELSE 'Above 20'
    END

    SELECT 
    CASE 
        WHEN wait_time_mins <= 5 THEN '0-5 mins'
        WHEN wait_time_mins <= 10 THEN '6-10 mins'
        WHEN wait_time_mins <= 15 THEN '11-15 mins'
        ELSE 'Above 15 mins'
    END AS wait_time_range,
    COUNT(*) AS total,
    SUM(CASE WHEN trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) AS cancelled,
    ROUND(SUM(CASE WHEN trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS cancel_rate
FROM trips
GROUP BY 
    CASE 
        WHEN wait_time_mins <= 5 THEN '0-5 mins'
        WHEN wait_time_mins <= 10 THEN '6-10 mins'
        WHEN wait_time_mins <= 15 THEN '11-15 mins'
        ELSE 'Above 15 mins'
    END
ORDER BY cancel_rate DESC


SELECT 
    CASE 
        WHEN wait_time_mins <= 5 THEN '0-5 mins'
        WHEN wait_time_mins <= 10 THEN '6-10 mins'
        ELSE 'Above 10 mins'
    END AS wait_range,
    CASE 
        WHEN fare_difference <= 5 THEN '0-5'
        WHEN fare_difference <= 10 THEN '6-10'
        ELSE 'Above 10'
    END AS fare_range,
    COUNT(*) AS total,
    SUM(CASE WHEN trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) AS cancelled,
    ROUND(SUM(CASE WHEN trip_status = 'Cancelled by Passenger' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS cancel_rate
FROM trips
GROUP BY 
    CASE 
        WHEN wait_time_mins <= 5 THEN '0-5 mins'
        WHEN wait_time_mins <= 10 THEN '6-10 mins'
        ELSE 'Above 10 mins'
    END,
    CASE 
        WHEN fare_difference <= 5 THEN '0-5'
        WHEN fare_difference <= 10 THEN '6-10'
        ELSE 'Above 10'
    END
ORDER BY cancel_rate DESC
use indrive