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

-- Nan confirmation check 

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

-- Column distribution

select Weather, count(*) from amazon_delivery group by Weather order by count(*) desc;
select Traffic, count(*) from amazon_delivery group by Traffic order by count(*) desc;
select Vehicle, count(*) from amazon_delivery group by Vehicle order by count(*) desc;

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

-- Day-of-week shows no meaningful pattern (119.8-131.6 min range across all 7 days).
-- Hour-of-day is different: no orders 1am-7am, delivery time and order volume both
-- spike together in the 17-23 window (peak 146-149 min at hours 19-21), dropping
-- back down by hour 22-23. Plausibly overlaps with evening rush-hour traffic,
-- consistent with traffic's dominant role found earlier, though not independently
-- re-confirmed here.

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

-- Grocery averages ~26.5 min vs ~130 min for every other category (confirmed via
-- individual delivery times, not an averaging artifact). Deep-dive by Area/Vehicle/
-- Rating/Weather/Traffic mostly reconfirms earlier patterns (rating cliff, traffic
-- dominance, Sunny fastest) within this faster subset -- no new anomaly surfaced.
-- Semi-Urban here (n=8) too thin to weigh.

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

-- Negative-latitude check (dangling from earlier data exploration)

select * from amazon_delivery where Store_Latitude < 0 or Drop_Latitude < 0;

-- Fix: sign-flip error. 188 rows have negative Store_Latitude; 27 of those also have
-- negative Store_Longitude. Drop_Latitude is never negative. ABS() on both columns
-- brings all resulting distances into a realistic 1.5-21 km range (verified against
-- the full dataset before applying).

SET SQL_SAFE_UPDATES = 0;

update amazon_delivery
set Store_Latitude = abs(Store_Latitude),
    Store_Longitude = abs(Store_Longitude)
where Store_Latitude < 0;

SET SQL_SAFE_UPDATES = 1;

-- Preview: check calculated distances look reasonable before full analysis

select Order_ID, Delivery_Time, sqrt(power(Drop_Latitude - Store_Latitude, 2) + power(Drop_Longitude - Store_Longitude, 2)) * 111 as approx_distance_km from amazon_delivery
where Store_Latitude != 0 and Store_Longitude != 0 and Drop_Latitude != 0 and Drop_Longitude != 0 limit 20;

-- Distance-bucketed delivery time

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

-- Delivery time rises with distance but plateaus past ~10km (141.9 vs 142.3 min).
-- High baseline even at 0-2km (~102 min) suggests fixed overhead dominates over travel time.

-- Distance x Traffic

select 
  case 
    when approx_distance_km < 2 then '0-2 km'
    when approx_distance_km < 5 then '2-5 km'
    when approx_distance_km < 10 then '5-10 km'
    when approx_distance_km < 20 then '10-20 km'
    else '20+ km'
  end as distance_bucket,
  Traffic,
  count(*), avg(Delivery_Time)
from (
  select Delivery_Time, Traffic,
  sqrt(power(Drop_Latitude - Store_Latitude, 2) + power(Drop_Longitude - Store_Longitude, 2)) * 111 as approx_distance_km
  from amazon_delivery
  where Store_Latitude != 0 and Store_Longitude != 0 
  and Drop_Latitude != 0 and Drop_Longitude != 0
  and Traffic is not null
) as distances
group by distance_bucket, Traffic
order by min(approx_distance_km), Traffic;

-- Traffic dominates over distance: Low stays ~93-115 min across all distances,
-- while Jam adds 30-65 min at the same distance. Grid isn't fully crossed —
-- 0-2km has no Jam/Medium; 10km+ has no High traffic.

-- Distance x Weather

select 
  case 
    when approx_distance_km < 2 then '0-2 km'
    when approx_distance_km < 5 then '2-5 km'
    when approx_distance_km < 10 then '5-10 km'
    when approx_distance_km < 20 then '10-20 km'
    else '20+ km'
  end as distance_bucket,
  Weather,
  count(*), avg(Delivery_Time)
from (
  select Delivery_Time, Weather,
  sqrt(power(Drop_Latitude - Store_Latitude, 2) + power(Drop_Longitude - Store_Longitude, 2)) * 111 as approx_distance_km
  from amazon_delivery
  where Store_Latitude != 0 and Store_Longitude != 0 
  and Drop_Latitude != 0 and Drop_Longitude != 0
  and Weather is not null
) as distances
group by distance_bucket, Weather
order by min(approx_distance_km), Weather;

-- Sunny fastest across every distance bucket. Cloudy/Fog spike sharply past 10km
-- (+55-78 min) while other weather types barely move — worth checking against traffic.

-- Distance x Weather x Traffic (Cloudy/Fog only, checking against traffic confound)

select 
  case 
    when approx_distance_km < 10 then 'under 10 km'
    else '10+ km'
  end as distance_bucket,
  Weather,
  Traffic,
  count(*), avg(Delivery_Time)
from (
  select Delivery_Time, Weather, Traffic,
  sqrt(power(Drop_Latitude - Store_Latitude, 2) + power(Drop_Longitude - Store_Longitude, 2)) * 111 as approx_distance_km
  from amazon_delivery
  where Store_Latitude != 0 and Store_Longitude != 0 
  and Drop_Latitude != 0 and Drop_Longitude != 0
  and Weather is not null and Traffic is not null
) as distances
where Weather in ('Cloudy','Fog')
group by distance_bucket, Weather, Traffic
order by distance_bucket, Weather, Traffic;

-- Distance x Weather x Traffic (all weather types, full comparison)

select 
  case 
    when approx_distance_km < 10 then 'under 10 km'
    else '10+ km'
  end as distance_bucket,
  Weather,
  Traffic,
  count(*), avg(Delivery_Time)
from (
  select Delivery_Time, Weather, Traffic,
  sqrt(power(Drop_Latitude - Store_Latitude, 2) + power(Drop_Longitude - Store_Longitude, 2)) * 111 as approx_distance_km
  from amazon_delivery
  where Store_Latitude != 0 and Store_Longitude != 0 
  and Drop_Latitude != 0 and Drop_Longitude != 0
  and Weather is not null and Traffic is not null
) as distances
group by distance_bucket, Weather, Traffic
order by distance_bucket, Weather, Traffic;

-- Confirmed: Cloudy/Fog effect is independent of traffic. At every traffic level,
-- Cloudy/Fog add 55-78 min past 10km; other weather types add far less (some even
-- get faster under Low traffic). Pattern is real, mechanism unconfirmed (no visibility
-- data to explain it). Also note: High traffic has zero rows at 10km+.

-- Vehicle x area

select Area, Vehicle, count(*), avg(Delivery_Time) from amazon_delivery where Area is not null and Vehicle is not null group by Area, Vehicle order by Area, Vehicle;

-- Area x traffic

select Area, Traffic, count(*), avg(Delivery_Time) from amazon_delivery where Area is not null and Traffic is not null group by Area, Traffic order by Area, Traffic;

-- Vehicle barely moves delivery time within an area; Area swings it 100+ min.
-- Semi-Urban averages ~240 min, far above other areas -- and stays ~89 min slower
-- than Metropolitan even within the same traffic level (Jam, n=126 both), ruling out
-- traffic as the explanation. Area has a genuine independent effect.
-- Note: Semi-Urban has no Low-traffic rows; several other cells too thin to trust alone.

-- Agent rating x delivery time

select round(Agent_Rating, 1) as agent_rating, count(*), avg(Delivery_Time) from amazon_delivery where agent_rating is not null group by round(Agent_Rating, 1) order by agent_rating desc;

-- Ratings show a clear cliff, not a gradual slope: 4.5+ averages ~112-121 min,
-- below 4.5 jumps to ~163-182 min. Injected clusters (1.0, 6.0) don't fully fit --
-- 6.0 sits in the fast tier as expected, but 1.0 is faster than genuine low ratings.

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

-- Corrected pickup gap (accounts for midnight rollover)

select avg(
  case 
    when Pickup_Time < Order_Time then timestampdiff(minute, Order_Time, Pickup_Time) + 1440
    else timestampdiff(minute, Order_Time, Pickup_Time)
  end) as avg_pickup_gap_corrected
from amazon_delivery where Order_Time is not null and Pickup_Time is not null;    

-- Uncorrected average is negative (-17.3 min) due to midnight rollover (Order_Time ~23:45-23:55,
-- Pickup_Time ~00:00-00:10). Corrected average: 9.99 min. Breakdown by Traffic and hour confirms
-- the rollover error was concentrated almost entirely in Low traffic and hour 23 (both show
-- extreme negative values uncorrected; every other group was already ~10 min). Once corrected,
-- pickup gap is flat -- ~10 min regardless of traffic or time of day, unlike delivery time.


-- KEY INSIGHTS

-- 1. Traffic level affects delivery time far more than distance does. At the same traffic level, 
-- delivery time barely changes with distance; but at the same distance, Jam traffic adds 30-65 
-- minutes compared to Low traffic.

-- 2. Delivery area affects delivery time on its own, separate from traffic. Semi-Urban orders 
-- average around 240 minutes versus 98-135 minutes in other areas, and this gap holds even when 
-- comparing orders under the same traffic level.

-- 3. Cloudy and Fog weather slow down long-distance deliveries specifically. Past 10km, delivery 
-- time under Cloudy or Fog rises by 55-78 minutes at every traffic level, while other weather types 
-- show a much smaller increase.

-- 4. Higher-rated agents deliver noticeably faster, but the change happens as a sharp jump rather 
-- than a gradual improvement. Agents rated 4.5 and above average 112-121 minutes; agents rated below 
-- 4.5 average 163-182 minutes.

-- 5. Grocery orders deliver roughly five times faster than every other product category, averaging 
-- 26.5 minutes against approximately 130 minutes elsewhere, confirmed at the individual order level.

-- 6. The time between order placement and agent pickup stays steady at around 10 minutes, no matter 
-- the traffic level or time of day. This means delays happen after pickup, not before it.

-- 7. Order volume and delivery time both increase through the 17:00-23:00 window, peaking at 146-149 
-- minutes between 19:00-21:00; no orders are recorded between 1:00 and 7:00. Day of week shows no 
-- similar pattern, staying within a 12-minute range across all seven days.

-- 8. A latitude/longitude sign-flip error was found and corrected, affecting 215 rows where 
-- coordinates were recorded as negative instead of positive.

-- 9. Two small groups of agents (91 rows total) had age and rating values that did not match any 
-- other agent in the dataset, and did not follow the normal pattern between rating and delivery 
-- time. These are likely artificial test values rather than real agent data.

-- CONCLUSION

-- The dataset was cleaned and standardized in SQL, correcting a coordinate error, placeholder 
-- nulls, a categorical typo, and date/time formatting. The analysis examined how delivery time 
-- relates to distance, traffic, weather, area, agent rating, category, and time of day, checking 
-- each pattern against other factors to confirm it was genuine. Traffic and delivery area emerged 
-- as the strongest factors behind delivery time, with distance mattering less past about 10km. 
-- Weather slowed deliveries mainly under Cloudy or Fog at longer distances, and agent rating showed 
-- a sudden jump rather than a steady improvement. Grocery orders were consistently faster than other 
-- categories, and a steady order-to-pickup time suggests delays build up during the delivery itself.amazon_delivery
