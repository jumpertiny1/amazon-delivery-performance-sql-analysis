-- DATABASE SETUP

create database if not exists amazon_delivery_analysis;

use amazon_delivery_analysis;

-- DATA EXPLORATION

describe amazon_delivery;

select * from amazon_delivery limit 20;

select count(*) from amazon_delivery;

select count(*) Order_ID from amazon_delivery;

select count(distinct(Order_ID)) from amazon_delivery;

-- Distinct value checks

select distinct Agent_Age from amazon_delivery;
select count(distinct(Agent_Age)) from amazon_delivery;

select distinct Agent_Rating from amazon_delivery;
select count(distinct(Agent_Rating)) from amazon_delivery;

select distinct Store_Latitude from amazon_delivery;
select count(distinct(Store_Latitude)) from amazon_delivery;

select distinct Store_Longitude from amazon_delivery;
select count(distinct(Store_Longitude)) from amazon_delivery;

select distinct Drop_Latitude from amazon_delivery;
select count(distinct(Drop_Latitude)) from amazon_delivery;

select distinct Drop_Longitude from amazon_delivery;
select count(distinct(Drop_Longitude)) from amazon_delivery;

select distinct Order_Date from amazon_delivery;
select count(distinct(Order_Date)) from amazon_delivery;

select distinct Order_Time from amazon_delivery;
select count(distinct(Order_Time)) from amazon_delivery;

select distinct Pickup_Time from amazon_delivery;
select count(distinct(Pickup_Time)) from amazon_delivery;

select distinct Weather from amazon_delivery;
select count(distinct(Weather)) from amazon_delivery;

select distinct Traffic from amazon_delivery;
select count(distinct(Traffic)) from amazon_delivery;

select distinct Vehicle from amazon_delivery;
select count(distinct(Vehicle)) from amazon_delivery;

select distinct Area from amazon_delivery;
select count(distinct(Area)) from amazon_delivery;

select distinct Delivery_Time from amazon_delivery;
select count(distinct(Delivery_Time)) from amazon_delivery;

select distinct Category from amazon_delivery;
select count(distinct(Category)) from amazon_delivery;

-- Min/max/avg for numeric columns

select avg(Agent_Age), max(Agent_Age), min(Agent_Age) from amazon_delivery;
select avg(Agent_Rating), max(Agent_Rating), min(Agent_Rating) from amazon_delivery;
select max(Store_Latitude), min(Store_Latitude) from amazon_delivery;
select max(Store_Longitude), min(Store_Longitude) from amazon_delivery;
select max(Drop_Latitude), min(Drop_Latitude) from amazon_delivery;
select max(Drop_Longitude), min(Drop_Longitude) from amazon_delivery;
select max(Order_Date), min(Order_Date) from amazon_delivery;
select max(hour(Order_Time)), min(hour(Order_Time)) from amazon_delivery;
select max(hour(Pickup_Time)), min(hour(Pickup_Time)) from amazon_delivery; 

-- Null checks

select sum(Order_ID is null) as null_order_id,
sum(Agent_Age is null) as null_agent_age,
sum(Agent_Rating is null) as null_agent_rating,
sum(Store_Latitude is null) as null_store_latitude,
sum(Store_Longitude is null) as null_store_latitude,
sum(Drop_Latitude is null) as null_drop_latitude,
sum(Drop_Longitude is null) as null_drop_longitude,
sum(Order_Date is null) as null_order_date,
sum(Order_Time is null) as null_order_Time,
sum(Pickup_Time is null) as null_pickup_time,
sum(Weather is null) as null_weather,
sum(Traffic is null) as null_traffic,
sum(Vehicle is null) as null_vehicle,
sum(Area is null) as null_area,
sum(Delivery_Time is null) as null_delivery_time,
sum(Category is null) as null_category from amazon_delivery;

-- Duplicate row check 

select *, count(*) from amazon_delivery group by Order_ID, Agent_Age, Agent_Rating, Store_Latitude, Store_Longitude, Drop_Latitude,
Drop_Longitude, Order_Date, Order_Time, Pickup_Time, Weather, Traffic, Vehicle, Area, Delivery_Time, Category having count(*) > 1;

-- Whitespace checks on all text columns 

select * from amazon_delivery where Order_ID != trim(Order_ID);
select * from amazon_delivery where Order_Date != trim(Order_Date);
select * from amazon_delivery where Order_Time != trim(Order_Time);
select * from amazon_delivery where Pickup_Time != trim(Pickup_Time);
select * from amazon_delivery where Weather != trim(Weather);
select * from amazon_delivery where Traffic != trim(Traffic);
select * from amazon_delivery where Vehicle != trim(Vehicle);
select * from amazon_delivery where Area != trim(Area);
select * from amazon_delivery where Category != trim(Category);

-- Latitude/longitude range checks 

select * from amazon_delivery where Store_Latitude < -90 or Store_Latitude > 90
or Store_Longitude < -180 or Store_Longitude > 180 
or Drop_Latitude < -90 or Drop_Latitude > 90
or Drop_Longitude < -180 or Drop_Longitude > 180;

-- Latitude/longitude zero value check

select * from amazon_delivery where Store_Latitude = 0 or Store_Longitude = 0
or Drop_Latitude = 0 or Drop_Longitude = 0;

select count(*) from amazon_delivery where Store_Latitude = 0;
select count(*) from amazon_delivery where Store_Longitude = 0;
select count(*) from amazon_delivery where Drop_Latitude = 0;
select count(*) from amazon_delivery where Drop_Longitude = 0;

-- Date/time format inspection 

select Order_Date, Order_Time, Pickup_Time from amazon_delivery;	

-- Logical order and pickup_time check

select * from amazon_delivery where Pickup_Time < Order_Time; 

-- Distribution checks (confirm min/max aren't lone outliers, not the whole picture)

select Agent_Age, count(*) from amazon_delivery group by Agent_Age order by Agent_Age;
select round(Agent_Rating,1) as Agent_Rating, count(*) from amazon_delivery group by round(Agent_Rating,1) order by Agent_Rating;
select Delivery_Time, count(*) from amazon_delivery group by Delivery_Time order by Delivery_Time;

-- Whitespaces confirmation check

select distinct Order_Time from amazon_delivery where Order_Time != trim(Order_Time) limit 20;
select distinct Weather from amazon_delivery where Weather != trim(Weather) limit 20;
select distinct Traffic from amazon_delivery where Traffic != trim(Traffic) limit 20;
select distinct Area from amazon_delivery where Area != trim(Area) limit 20;

select
sum(Order_ID = "NaN") as nan_order_id,
sum(Agent_age = "NaN") as nan_agent_age,
sum(Agent_Rating = "NaN") as nan_agent_rating,
sum(Store_Latitude = "NaN") as nan_store_latitude,
sum(Store_Longitude = "NaN") as nan_store_longitude,
sum(Drop_Latitude = "NaN") as nan_drop_latitude,
sum(Drop_Longitude = "NaN") as nan_drop_longitude,
sum(Order_Date = "NaN") as nan_order_date,
sum(Order_Time = "NaN") as nan_Order_Time, 
sum(Pickup_Time = "NaN") as nan_pickup_Time,
sum(Weather = "NaN") as nan_weather,
sum(Traffic = "NaN") as nan_traffic,
sum(Vehicle = "NaN") as nan_vehicle,
sum(Area = "NaN") as nan_area,
sum(Delivery_Time = "NaN") as nan_delivery_time,
sum(Category = "NaN") as nan_category from amazon_delivery;

-- Confirming Lat/long "0" and "NaN" checks are the same population

select count(*) from amazon_delivery where Store_Latitude = 0 and Store_Latitude = "NaN";

-- Re-check NaN with trim, to catch any whitespace-padded NaNs missed by exact-match 

select sum(trim(Order_ID) = "NaN") as nan_order_id,
sum(trim(Order_Date) = "NaN") as nan_order_date,
sum(trim(Order_Time) = "NaN") as nan_order_time,
sum(trim(Pickup_Time) = "NaN") as nan_pickup_time,
sum(trim(Weather) = "NaN") as nan_weather,
sum(trim(Traffic) = "NaN") as nan_traffic,
sum(trim(Vehicle) = "NaN") as nan_vehicle,
sum(trim(Area) = "NaN") as nan_area,
sum(trim(Category) = "NaN") as nan_category from amazon_delivery;

-- Confirming scope of the "Metropolitian" typo

select count(*) from amazon_delivery where Area = "Metropolitian";

-- Order_ID duplicate check (distinct from full-row duplicate check) 

select Order_ID, count(*) from amazon_delivery group by Order_ID having count(*) > 1;
select count(*) - count(distinct Order_ID) as duplicate_order_ids from amazon_delivery; 

-- Order_ID length check (to size varchar for primary key converion)

select min(length(Order_ID)), max(length(Order_ID)) from amazon_delivery;

-- Delivery_Time outlier check

select * from amazon_delivery where Delivery_Time <= 0;

select count(*), Agent_Age from amazon_delivery group by Agent_Age;

-- 'Metropolitian' spellcheck to find the numbers off values with wrong spelling.

select count(*) from amazon_delivery where(trim(Area)) = 'Metropolitian';
select distinct Area from amazon_delivery;
select Area, count(*) from amazon_delivery group by Area;

-- Final check to confirm 'NaN' and white-spaces

select count(*) from amazon_delivery 
where trim(Order_Time) = 'NaN' 
and trim(Weather) = 'NaN' 
and trim(Traffic) = 'NaN';

-- CLEANING AND STANDARDISATION

-- Turning sql safe off

SET SQL_SAFE_UPDATES = 0;  

-- Area: whitespace trim and spelling fix

update amazon_delivery set Area = trim(Area);
update amazon_delivery set Area = 'Metropolitan' where Area = 'Metropolitian';

-- Converting "NaN" text to real NULL across Order_Time, Weather, Traffic

update amazon_delivery set Order_Time = null where trim(Order_Time) = 'NaN';
update amazon_delivery set Weather = null where trim(Weather) = 'NaN';
update amazon_delivery set Traffic = null where trim(Traffic) = 'NaN';

-- Converting varchar for Order_ID correctly for primary key

alter table amazon_delivery modify column Order_ID varchar(15);
alter table amazon_delivery add primary key (Order_ID);

-- Correcting date/time types for Order_Date, Order_Time and Pickup_Time

alter table amazon_delivery modify column Order_Date date; 
alter table amazon_delivery modify column Order_Time time;
alter table amazon_delivery modify column Pickup_Time time;

-- confirming updates and modifications 

describe amazon_delivery;

-- EXPLORATORY DATA ANALYSIS

-- Data volume & coverage

select min(Order_Date), max(Order_Date) from amazon_delivery;
select count(*) from amazon_delivery;
select Area, count(*) from amazon_delivery group by Area order by count(*) desc;
select Category, count(*) from amazon_delivery group by Category order by count(*) desc;

-- Delivery times across categorical columns

select max(Delivery_Time), min(Delivery_Time), avg(Delivery_Time) from amazon_delivery;
select Weather, avg(Delivery_Time) as avg_delivery_time from amazon_delivery group by Weather order by avg_delivery_time desc; 
select Traffic, avg(Delivery_Time) as avg_delivery_time from amazon_delivery group by Traffic order by avg_delivery_time desc;
select Vehicle, avg(Delivery_Time) as avg_delivery_time from amazon_delivery group by Vehicle order by avg_delivery_time desc;
select Area, avg(Delivery_Time) as avg_delivery_time from amazon_delivery group by Area order by avg_delivery_time desc;
select Category, avg(Delivery_Time) as avg_delivery_time from amazon_delivery group by Category order by avg_delivery_time desc;	

-- Delivery times by Weather / Traffic (excluding NULLs for clean comparison)

select Weather, avg(Delivery_Time) as avg_delivery_time, count(*) from amazon_delivery where Weather is not null group by Weather order by avg_delivery_time desc;
select Traffic, avg(Delivery_Time) as avg_delivery_time, count(*) from amazon_delivery where Traffic is not null group by Traffic order by avg_delivery_time desc;
select Vehicle, avg(Delivery_Time) as avg_delivery_time, count(*) from amazon_delivery where Vehicle is not null group by Vehicle order by avg_delivery_time desc;
select Area, avg(Delivery_Time) as avg_delivery_time, count(*) from amazon_delivery where Area is not null group by Area order by avg_delivery_time desc;
select Category, avg(Delivery_Time) as avg_delivery_time, count(*) from amazon_delivery where Category is not null group by Category order by avg_delivery_time desc;

-- Agent performance 

select round(Agent_Rating,1) as agent_rating, avg(Delivery_time), count(*) from amazon_delivery group by round(Agent_Rating,1) order by agent_rating desc;
select Agent_Age, avg(Delivery_Time), count(*) from amazon_delivery group by Agent_Age order by Agent_Age desc;

-- Time-based patterns

select hour(Order_Time) as order_hour, count(*) as total_orders, avg(Delivery_Time) from amazon_delivery where Order_Time is not null group by Order_hour order by order_hour;
select dayname(Order_Date) as order_day, count(*) as total_orders, avg(Delivery_Time) from amazon_delivery group by order_day order by total_orders;  
select hour(Order_Time), count(*) from amazon_delivery where Order_Time is not null group by hour(Order_Time) order by hour(Order_Time);

set sql_safe_updates = 1;

-- Semi-urban + grocery check against delivery time

select Delivery_Time, Area from amazon_delivery where Area = "Semi-Urban" group by Delivery_Time order by Delivery_Time;
select Delivery_Time, Category from amazon_delivery where Category = "Grocery" group by Delivery_Time order by Delivery_Time;

-- Semi-urban + traffic check

select Traffic, count(*), avg(Delivery_Time) from amazon_delivery where Area = "Semi-Urban" group by Traffic order by Traffic;

-- Grocery overall breakdown

select Area, count(*), avg(Delivery_Time) from amazon_delivery where Category = "Grocery" group by Area;
select Vehicle, count(*), avg(Delivery_Time) from amazon_delivery where Category = "Grocery" group by Vehicle;
select Order_Date, count(*), avg(Delivery_Time) from amazon_delivery where Category = "Grocery" group by Order_Date;
select Agent_Rating, count(*), avg(Delivery_Time) from amazon_delivery where Category = "Grocery" group by Agent_Rating;
select Weather, count(*), avg(Delivery_Time) from amazon_delivery where Category = "Grocery" group by Weather;
select Traffic, count(*), avg(Delivery_Time) from amazon_delivery where Category = "Grocery" group by Traffic;

-- Agent_rating range sanity check

select min(Agent_Rating), max(Agent_Rating) from amazon_delivery;

-- Agent_Age and Agent_Rating extreme values — checking for correlation

select round(Agent_Rating, 1) as agent_rating, avg(Delivery_Time), count(*) from amazon_delivery where Agent_Rating is not null group by round(Agent_Rating, 1) order by agent_rating desc;
select Agent_Age, avg(Delivery_Time), count(*) from amazon_delivery where Agent_Age is not null group by Agent_Age order by Agent_Age;

select count(*) from amazon_delivery where Agent_Rating = 6 and Agent_Age = 50;
select count(*) from amazon_delivery where Agent_Rating = 1 and Agent_Age = 15;

-- Confirmed: Agent_Age and Agent_Rating extremes are paired, not independent.
-- All 53 agents aged 50 hold Agent_Rating = 6; all 38 agents aged 15 hold Agent_Rating = 1.
-- Both fall outside the otherwise uniform Age 20-39 / Rating ~2.5-5.9 range seen across the rest 
-- of the dataset — likely deliberately injected edge cases from data generation, not organic extremes.

-- Delivery distance (approximate, using lat/long)

-- Preview: check calculated distances look reasonable before full analysis

select Order_ID, Delivery_Time, sqrt(power(Drop_Latitude - Store_Latitude, 2) + power(Drop_Longitude - Store_Longitude, 2)) * 111 as approx_distance_km from amazon_delivery
where Store_Latitude != 0 and Store_Longitude != 0 and Drop_Latitude != 0 and Drop_Longitude != 0 limit 20;

select 
  case 
    when approx_distance_km < 2 then '0-2 km'
    when approx_distance_km < 5 then '2-5 km'
    when approx_distance_km < 10 then '5-10 km'
    when approx_distance_km < 20 then '10-20 km'
    else '20+ km'
  end as distance_bucket,
  count(*), avg(Delivery_Time)
from (
  select Delivery_Time,
  sqrt(power(Drop_Latitude - Store_Latitude, 2) + power(Drop_Longitude - Store_Longitude, 2)) * 111 as approx_distance_km
  from amazon_delivery
  where Store_Latitude != 0 and Store_Longitude != 0 
  and Drop_Latitude != 0 and Drop_Longitude != 0
) as distances
group by distance_bucket
order by min(approx_distance_km);

-- Order-to-pickup gap (time between order placed and agent pickup)

select avg(timestampdiff(minute, Order_Time, Pickup_Time)) as avg_pickup_gap from amazon_delivery where Order_Time is not null and Pickup_Time is not null;

-- Check for negative gaps (midnight rollover artifact, same issue as Pickup_Time < Order_Time check)

select * from amazon_delivery where timestampdiff(minute, Order_Time, Pickup_Time) < 0;

-- Pickup gap by Traffic

select Traffic, avg(timestampdiff(minute, Order_Time, Pickup_Time)) as avg_pickup_gap, count(*) from amazon_delivery where Order_Time is not null 
and Pickup_Time is not null and Traffic is not null group by Traffic order by avg_pickup_gap desc;

-- Pickup gap by hour of day

select hour(Order_Time) as order_hour, avg(timestampdiff(minute, Order_Time, Pickup_Time)) as avg_pickup_gap, count(*) from amazon_delivery where 
Order_Time is not null and Pickup_Time is not null group by order_hour order by order_hour;

select avg(
  case 
    when Pickup_Time < Order_Time then timestampdiff(minute, Order_Time, Pickup_Time) + 1440
    else timestampdiff(minute, Order_Time, Pickup_Time)
  end) as avg_pickup_gap_corrected
from amazon_delivery where Order_Time is not null and Pickup_Time is not null;    

select * from amazon_delivery where Store_Latitude < 0 or Drop_Latitude < 0;