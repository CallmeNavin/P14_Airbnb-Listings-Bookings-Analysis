# P14_Airbnb-Listings-Bookings-Analysis

**VERSION 1**

**A. Project Overview**

- This project aims to analyze various aspects of the Albany Airbnb market. In this version, I'd like to get into 03 main ideas:
  + Listing Characteristics: Overview of the type, size, and features of listings in Albany, helping identify the most common accommodation types and pricing ranges (listings.csv)
  + Availability & Pricing Trends: Examine how pricing and availability fluctuate over time and across different types of listings (calendar.csv and listings.csv)
  + Guest Feedback: Sentiment analysis and topic modeling to understand guest satisfaction and common issues (reviews.csv)

**B. Dataset Information**

_**Source**_

- New York Airbnb Open Data (From Kaggle): capture key aspects of Albany’s Airbnb ecosystem

https://www.kaggle.com/datasets/rhonarosecortez/new-york-airbnb-open-data?

- The dataset includes 03 files:
  + listings.csv: Information on property types, pricing, and host profiles.
  + calendar.csv: Day to day availability and pricing records.
  + reviews.csv: Guest reviews on each listings.

_**Period**_

- 

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
  + Export cleaned data
- Using Power BI for Dashboard visualize & find insights.
- Note:
  + SQL in this project is just used for data checking cause mấy bước kia làm ở Power BI tiện lợi  hơn
  + After identifying blanks and outliers, further adjustments and scenario testing will be managed directly in Power BI dashboards or within the SQL workflow to ensure clean and reliable insights for decision-making

**D. Key Findings & Actionable Plans**

_**Key Findings**_

- 

_**Actionable Plans**_

- 

**About Me**

Hi, I'm Navin (Bao Vy) – an aspiring Data Analyst passionate about turning raw data into actionable business insights. I’m eager to contribute to data-driven decision making and help organizations translate analytics into business impact. For more details, please reach out at:

🌐 LinkedIn: https://www.linkedin.com/in/navin826/

📂 Portfolio: https://github.com/CallmeNavin/
