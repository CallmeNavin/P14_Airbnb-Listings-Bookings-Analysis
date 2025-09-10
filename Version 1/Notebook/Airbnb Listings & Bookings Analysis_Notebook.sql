-- I. Data Cleaning
--- I.1. Check Column Type
SELECT 
  column_name
  , data_type
from information_schema.columns
Where table_schema = 'public';
--- I.2. Check %blank/null
With listings_cleaned as(
  SELECT
    "id"
    , "room_type"
    , Cast(Nullif(Replace(host_response_rate, '%', ''), 'N/A') as Integer) as host_response_rate_num
    , Cast(Nullif(Replace(host_acceptance_rate, '%', ''), 'N/A') as Integer) as host_acceptance_rate_num
    , CAST(NULLIF(NULLIF(REPLACE(REPLACE(price, '$', ''), ',', ''), 'N/A'), '') AS NUMERIC) AS price_num
from public.listings)
SELECT
  SUM(Case When "id" is null then 1 else 0 end)*100/Count(*) as pct_blank_id
  , SUM(Case When "host_response_rate_num" is null then 1 else 0 end)*100/Count(*) as pct_blank_host_response_rate_num
  , SUM(Case When "host_acceptance_rate_num" is null then 1 else 0 end)*100/Count(*) as pct_blank_host_acceptance_rate_num
  , SUM(Case When "room_type" is null or "room_type" = '' then 1 else 0 end)*100/Count(*) as pct_blank_room_type
  , SUM(Case When "price_num" is null then 1 else 0 end)*100/Count(*) as pct_blank_price_num
from listings_cleaned;
With calendar_cleaned AS(
  SELECT
    listing_id
    , "date"
    , available
    , Cast(Nullif(Nullif(Replace(Replace(price, '$', ''), ',', ''), 'N/A'), '') as Numeric) as price_num
    , minimum_nights
    , maximum_nights
  From public.calendar)
Select 
  SUM(Case When "listing_id" is null then 1 else 0 end)*100/Count(*) as pct_blank_listing_id
  , SUM(Case When "date" is null then 1 else 0 end)*100/Count(*) as pct_blank_date
  , SUM(Case When "available" is null or "available" = '' then 1 else 0 end)*100/Count(*) as pct_blank_available
  , SUM(Case When "price_num" is null then 1 else 0 end)*100/Count(*) as pct_blank_price_num
  , SUM(Case When "minimum_nights" is null then 1 else 0 end)*100/Count(*) as pct_blank_minimum_nights
  , SUM(Case When "maximum_nights" is null then 1 else 0 end)*100/Count(*) as pct_blank_mmaximum_nights
from calendar_cleaned;
WITH reviews_cleaned as(
  SELECT
    listing_id
    , id
    , "date"
    , reviewer_id
    , reviewer_name
  From public.reviews)
SELECT
  SUM(Case When "listing_id" is null then 1 else 0 end)*100/Count(*) as pct_blank_listing_id
  , SUM(Case When "id" is null then 1 else 0 end)*100/Count(*) as pct_blank_id
  , SUM(Case When "date" is null then 1 else 0 end)*100/Count(*) as pct_blank_date
  , SUM(Case When "reviewer_id" is null then 1 else 0 end)*100/Count(*) as pct_blank_reviewer_id
  , SUM(Case When "reviewer_name" is null then 1 else 0 end)*100/Count(*) as pct_blank_reviewer_name
from reviews_cleaned;
--- I.3. Check %Zero Value
With listings_cleaned as(
  SELECT
    "id"
    , "room_type"
    , Cast(Nullif(Replace(host_response_rate, '%', ''), 'N/A') as Integer) as host_response_rate_num
    , Cast(Nullif(Replace(host_acceptance_rate, '%', ''), 'N/A') as Integer) as host_acceptance_rate_num
    , CAST(NULLIF(NULLIF(REPLACE(REPLACE(price, '$', ''), ',', ''), 'N/A'), '') AS NUMERIC) AS price_num
from public.listings)
SELECT
  SUM(Case When "id" = 0 then 1 Else 0 End)*100/Count(*) as pct_zero_id
  , SUM(Case When "host_response_rate_num" = 0 then 1 Else 0 End)*100/Count(*) as pct_zero_host_response_rate_num
  , SUM(Case When "host_acceptance_rate_num" = 0 then 1 Else 0 End)*100/Count(*) as pct_zero_host_acceptance_rate_num
  , SUM(Case When "price_num" = 0 then 1 Else 0 End)*100/Count(*) as pct_zero_price_num
from listings_cleaned;
With calendar_cleaned AS(
  SELECT
    listing_id
    , "date"
    , available
    , Cast(Nullif(Nullif(Replace(Replace(price, '$', ''), ',', ''), 'N/A'), '') as Numeric) as price_num
    , minimum_nights
    , maximum_nights
  From public.calendar)
SELECT
  SUM(Case When "listing_id" = 0 then 1 Else 0 End)*100/Count(*) as pct_zero_listing_id
  , SUM(Case When "date" is null then 1 Else 0 End)*100/Count(*) as pct_zero_date
  , SUM(Case When "price_num" = 0 then 1 Else 0 End)*100/Count(*) as pct_zero_price_num
  , SUM(Case When "minimum_nights" = 0 then 1 Else 0 End)*100/Count(*) as pct_zero_minimum_nights
  , SUM(Case When "maximum_nights" = 0 then 1 Else 0 End)*100/Count(*) as pct_zero_maximum_nights
from calendar_cleaned;
WITH reviews_cleaned as(
  SELECT
    listing_id
    , id
    , "date"
    , reviewer_id
    , reviewer_name
  From public.reviews)
SELECT
  SUM(Case When listing_id = 0 then 1 Else 0 end)*100/Count(*) as pct_zero_listing_id
  , SUM(Case When "id" = 0 then 1 Else 0 end)*100/Count(*) as pct_zero_id
  , SUM(Case When "date" is null then 1 Else 0 end)*100/Count(*) as pct_zero_date
  , SUM(Case When reviewer_id = 0 then 1 Else 0 end)*100/Count(*) as pct_zero_reviewer_id
from reviews_cleaned;
--- I.4. Check Outliers (price_num - listings)
With listings_cleaned as(
  SELECT
    "id"
    , "room_type"
    , Cast(Nullif(Replace(host_response_rate, '%', ''), 'N/A') as Integer) as host_response_rate_num
    , Cast(Nullif(Replace(host_acceptance_rate, '%', ''), 'N/A') as Integer) as host_acceptance_rate_num
    , CAST(NULLIF(NULLIF(REPLACE(REPLACE(price, '$', ''), ',', ''), 'N/A'), '') AS NUMERIC) AS price_num
from public.listings), 
  stats AS(
    SELECT
      PERCENTILE_CONT(0.25) Within Group (Order by price_num) as q1_price_num
      , PERCENTILE_CONT(0.75) Within Group (Order by price_num) as q3_price_num
    from listings_cleaned),
  bounds AS(
    SELECT
      q1_price_num
      , q3_price_num
      , (q1_price_num - 1.5 * (q3_price_num - q1_price_num)) as lower_bound_price_num
      , (q3_price_num + 1.5 * (q3_price_num - q1_price_num)) as upper_bound_price_num
    from stats)
SELECT
  listings_cleaned.*
from listings_cleaned, bounds
Where listings_cleaned.price_num < lower_bound_price_num
Or listings_cleaned.price_num > upper_bound_price_num;
--- I.4. Check Outliers (host_response_rate, host_acceptance_rate - listings)
With listings_cleaned as(
  SELECT
    "id"
    , "room_type"
    , Cast(Nullif(Replace(host_response_rate, '%', ''), 'N/A') as Integer) as host_response_rate_num
    , Cast(Nullif(Replace(host_acceptance_rate, '%', ''), 'N/A') as Integer) as host_acceptance_rate_num
    , CAST(NULLIF(NULLIF(REPLACE(REPLACE(price, '$', ''), ',', ''), 'N/A'), '') AS NUMERIC) AS price_num
from public.listings)
SELECT
  MIN(host_response_rate_num) as min_host_response_rate_num
  , MAX(host_response_rate_num) as max_host_response_rate_num
  , MIN(host_acceptance_rate_num) as min_host_acceptance_rate_num
  , max(host_acceptance_rate_num) as max_host_acceptance_rate_num
from listings_cleaned;
--- I.4. Check Outliers (date - reviews)
With 
  stats AS(
    SELECT
      PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY EXTRACT(EPOCH from "date")) as q1_date
      , PERCENTILE_CONT(0.75) WITHIN GROUP (order by extract(epoch from "date")) as q3_date
    from public.reviews),
    bounds AS(
      Select
        q1_date
        , q3_date
        , (q3_date - q1_date) as iqr_date
        , (q1_date - 1.5 * (q3_date - q1_date)) as lower_bound_date
        , (q1_date + 1.5 * (q3_date - q1_date)) as upper_bound_date
      from stats)
SELECT 
  public.reviews.*
from public.reviews, bounds
where EXTRACT(epoch from public.reviews.date) < lower_bound_date
or EXTRACT(epoch from public.reviews.date) > upper_bound_date;
SELECT
  MIN("date") as min_date
  , MAX("date") as max_date
from public.reviews;
--- I.4. Check Outliers (date - calendar)
With 
  stats AS(
    SELECT
      PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY EXTRACT(EPOCH from "date")) as q1_date
      , PERCENTILE_CONT(0.75) WITHIN GROUP (order by extract(epoch from "date")) as q3_date
    from public.calendar),
    bounds AS(
      Select
        q1_date
        , q3_date
        , (q3_date - q1_date) as iqr_date
        , (q1_date - 1.5 * (q3_date - q1_date)) as lower_bound_date
        , (q1_date + 1.5 * (q3_date - q1_date)) as upper_bound_date
      from stats)
SELECT 
  public.calendar.*
from public.calendar, bounds
where EXTRACT(epoch from public.calendar.date) < lower_bound_date
or EXTRACT(epoch from public.calendar.date) > upper_bound_date;
SELECT
  MIN("date") as min_date
  , MAX("date") as max_date
from public.calendar;
--- I.4. Check Outliers (price_num, minimum_nights, maximum_nights - calendar)
With calendar_cleaned AS(
  SELECT
    listing_id
    , "date"
    , available
    , Cast(Nullif(Nullif(Replace(Replace(price, '$', ''), ',', ''), 'N/A'), '') as Numeric) as price_num
    , minimum_nights
    , maximum_nights
  From public.calendar)
SELECT
  MIN(price_num) as min_price_num
  , MAX(price_num) as max_price_num
  , MIN(minimum_nights) as min_minimum_nights
  , MAX(minimum_nights) as max_minimum_nights
  , MIN(maximum_nights) as min_maximum_nights
  , MAX(maximum_nights) as max_maximum_nights
FROM calendar_cleaned;
-- II. Query for Insights
--- II.1. Listings
---- II.1.2. Histogram for host_response_rate_num, host_acceptance_rate_num
With listings_cleaned as(
  SELECT
    "id"
    , "room_type"
    , Cast(Nullif(Replace(host_response_rate, '%', ''), 'N/A') as Float) as host_response_rate_num
    , Cast(Nullif(Replace(host_acceptance_rate, '%', ''), 'N/A') as Float) as host_acceptance_rate_num
    , CAST(NULLIF(NULLIF(REPLACE(REPLACE(price, '$', ''), ',', ''), 'N/A'), '') AS Float) AS price_num
from public.listings)
SELECT
  "id"
  , "room_type"
  , host_response_rate_num as host_response_rate_num
  , host_acceptance_rate_num as host_acceptance_rate_num
  , price_num
FROM listings_cleaned;
-- II. Query for Insights
--- II.1. Listings
---- II.1.3. Group by host_response_rate, host_acceptance_rate
With listings_cleaned as(
  SELECT
    "id"
    , "room_type"
    , Cast(Nullif(Replace(host_response_rate, '%', ''), 'N/A') as Float) as host_response_rate_num
    , Cast(Nullif(Replace(host_acceptance_rate, '%', ''), 'N/A') as Float) as host_acceptance_rate_num
    , CAST(NULLIF(NULLIF(REPLACE(REPLACE(price, '$', ''), ',', ''), 'N/A'), '') AS Float) AS price_num
from public.listings)
SELECT
  CASE
    When host_response_rate_num < 50 then 'Low - Below 50'
    When host_response_rate_num between 50 and 80 then 'Medium - 50 to 80'
    Else 'High - > 80'
  END as host_response_rate_group
  , ROUND(AVG(price_num):: NUMERIC, 2) as avg_price_num
  , COUNT(*) as listings_count
from listings_cleaned
Group by host_response_rate_group
Order by avg_price_num;
With listings_cleaned as(
  SELECT
    "id"
    , "room_type"
    , Cast(Nullif(Replace(host_response_rate, '%', ''), 'N/A') as Float) as host_response_rate_num
    , Cast(Nullif(Replace(host_acceptance_rate, '%', ''), 'N/A') as Float) as host_acceptance_rate_num
    , CAST(NULLIF(NULLIF(REPLACE(REPLACE(price, '$', ''), ',', ''), 'N/A'), '') AS Float) AS price_num
from public.listings)
SELECT
  Case
    When host_acceptance_rate_num < 50 then 'Low - Below 50'
      When host_acceptance_rate_num between 50 and 80 then 'Medium - 50 to 80'
      Else 'High - > 80'
    END as host_acceptance_rate_group
    , ROUND(AVG(price_num):: NUMERIC, 2) as avg_price_num
    , COUNT(*) as listings_count
from listings_cleaned
Group by host_acceptance_rate_group
Order by avg_price_num;
-- III. Export Cleaned files
Create TABLE listings_cleaned (
    "id" BIGINT PRIMARY KEY
    , "room_type" TEXT
    , host_response_rate_num INT
    , host_acceptance_rate_num INT
    , price_num NUMERIC);
INSERT INTO listings_cleaned
  SELECT 
    "id"
    , "room_type"
    , Cast(Nullif(Replace(host_response_rate, '%', ''), 'N/A') as Integer)
    , Cast(Nullif(Replace(host_acceptance_rate, '%', ''), 'N/A') as Integer)
    , CAST(NULLIF(NULLIF(REPLACE(REPLACE(price, '$', ''), ',', ''), 'N/A'), '') as Numeric)
  from public.listings;
SELECT
  *
from listings_cleaned;
With calendar_cleaned AS(
  SELECT
    listing_id
    , "date"
    , available
    , Cast(Nullif(Nullif(Replace(Replace(price, '$', ''), ',', ''), 'N/A'), '') as Numeric) as price_num
    , minimum_nights
    , maximum_nights
  From public.calendar)
SELECT 
  listing_id
  , "date"
  , available
  , price_num
  , minimum_nights
  , maximum_nights 
FROM calendar_cleaned;
WITH reviews_cleaned as(
  SELECT
    listing_id
    , id
    , "date"
    , reviewer_id
    , reviewer_name
  From public.reviews)
SELECT 
  listing_id
  , "id"
  , "date"
  , reviewer_id
  , reviewer_name
from reviews_cleaned;