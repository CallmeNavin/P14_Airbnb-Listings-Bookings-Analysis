# P14_Airbnb-Listings-Bookings-Analysis

**VERSION 1**

**A. Project Overview**

- This project aims to analyze various aspects of the Albany Airbnb market. In this version, I'd like to get into an overview of market & focus on a little details to find room for improvement

**B. Dataset Information**

_**Source**_

- New York Airbnb Open Data (From Kaggle): capture key aspects of Albany’s Airbnb ecosystem

https://www.kaggle.com/datasets/rhonarosecortez/new-york-airbnb-open-data?

- The dataset includes 03 files:
  + listings.csv: Information on property types, pricing, and host profiles.
  + calendar.csv: Day to day availability and pricing records.
  + reviews.csv: Guest reviews on each listings.

_**Period**_

- The dataset covers multiple time frames: Reviews data spans 2014–2024, providing a long-term perspective on guest feedback. Calendar data spans Sep 2024–Sep 2025, capturing daily availability and pricing. Listings represent a snapshot of properties at the time of data extraction.

**C. Methodology**

- Imported Data: Dataset was imported into PostgreSQL (Neon Cloud) using DBeaver (CSV → Table mapping).
- Connection: Connected Neon Cloud to Mode Analytics through the PostgreSQL connector.
- SQL Queries: Executed directly in Mode. Each step produces a separate query result (see folder Query Results).
  + I. Data Cleaning:
    - I.1. Check Column Type
    - I.2. Check %Blank/Null - Check main columns:
      + listings: id, host_response_rate, host_acceptance_rate, room_type, price --> host_response_rate (3%), host_acceptance_rate (4%), price (6%)
      + calendar: listing_id, date, available, price, minimum_nights, maximum_nights
      + reviews: listing_id, id, date, reviewer_id, reviewer_name
    - I.3. Check %Zero Value - Check Numeric & date columns
    - I.4. Check Outliers - Check main columns (Use min/max or IQR base on cases):
      + listings: price_num, host_response_rate, host_acceptance_rate
      + calendar: date, minimum_nights, maximum_nights, price_num
      + reviews: date
  + II. Query for Insights:
    - I.1. Listings
      + II.1.2. Histogram for host_response_rate_num, host_acceptance_rate_num
    - I.2. Calendar & Reviews: Would be done in Power BI
  + Export cleaned data:
    - Listings data was exported into a new table with primary key constraints to ensure uniqueness.
    - Calendar and Reviews data were exported using CTE queries.
- Using Power BI for Dashboard visualize & find insights.
- Note:
  + SQL was mainly used for data cleaning and validation checks, while Power BI handled most of the visualization and final analysis.
  + After identifying blanks and outliers, further adjustments and scenario testing will be managed directly in Power BI dashboards or within the SQL workflow to ensure clean and reliable insights for decision-making

**D. Key Findings & Actionable Plans**

_**Key Findings**_

- The Average Actual Price is around 153 USD/night, very close to the Average Listed Price (gap ~28.8 USD), showing stable market pricing.
- A total of 381 active listings.
- Host Acceptance Rate (~88%) and Host Response Rate (~97%) are relatively high → indicating professional host behavior overall.
- Average price across months is stable (flat trend), with a few dips in February and September → could be off-season or missing data.
- The market is dominated by Entire home/apt (>74%), the most preferred room type among guests.
- Host acceptance rates are quite similar across low- and high-price groups (~32% vs ~39%) → potential to improve host engagement.
- Host response rates also show no clear difference across price groups (~36% vs ~37%) → potential to improve communication quality.

_**Actionable Plans**_

- Identify and train hosts with low acceptance/response rates to improve booking conversion.
- Encourage hosts to keep availability consistent, reducing “not available” periods.
- Focus marketing efforts on Entire home/apt, while incentivizing Private room hosts to diversify offerings.
- Leverage seasonality (off-season months) with targeted promotions to balance demand.

**About Me**

Hi, I'm Navin (Bao Vy) – an aspiring Data Analyst passionate about turning raw data into actionable business insights. I’m eager to contribute to data-driven decision making and help organizations translate analytics into business impact. For more details, please reach out at:

🌐 LinkedIn: https://www.linkedin.com/in/navin826/

📂 Portfolio: https://github.com/CallmeNavin/
