
# 🏅 Olympic History 120 Years: SQL Data Analysis

This project focuses on the **Exploratory Data Analysis (EDA)** and structural **normalization** of a historical dataset covering the Olympic Games from 1896 to 2016. The core analysis was performed using **SQL** (PostgreSQL) after initial data preparation in Python.

## 💾 Data Preparation Pipeline

The analysis began with two primary datasets: `athlete_events.csv` (containing athlete and event details) and `noc_regions.csv` (a lookup table for country codes).

### Initial Cleaning in Python (`first_analysis.ipynb`)

Before entering the database, the raw data underwent essential cleaning using Pandas. Missing values ($NaN$) in critical columns were addressed: **Age**, **Height**, and **Weight** were imputed using the median, while the **Medal** column's missing values were replaced with the string `'0'` (signifying no medal) to streamline the subsequent SQL queries. This process generated clean CSV files, which were then loaded into the PostgreSQL environment.

### Database Normalization (`database_normalization.sql`)

The loaded data initially resided in a denormalized form. To ensure data integrity, minimize redundancy, and align with best practices, the database structure was normalized to the **Third Normal Form (3NF)**.

The single large event table was decomposed into several smaller, related tables:
* The **`games`** table was created to store distinct information about each Olympic event (Year, Season, City).
* The original athlete details were separated into the **`athletes`** table.
* The core event results were placed in the **`results`** fact table, which links athletes and games through foreign keys.

A crucial final step involved further atomic breakdown in the **`athletes_cleared`** table, where the non-atomic `Name` column was parsed and split into separate **`first_name`** and **`last_name`** fields for more effective querying and analysis.

***

## 🔎 Key SQL Analytical Insights (`analysis.sql`)

The final, normalized structure was leveraged to extract meaningful insights using advanced SQL querying techniques, including `JOIN` operations, aggregate functions (`COUNT`, `SUM`, `AVG`), and Common Table Expressions (CTEs).

### Athlete and Team Performance Metrics

The analysis first established fundamental athlete statistics, calculating the minimum, maximum, and average **height** across all participants. It then provided a comprehensive count of the total medals awarded, breaking down the numbers into **Gold**, **Silver**, **Bronze**, and **No Medal** categories.

### Historical and Geo-political Trends

The SQL queries were designed to uncover historical trends by identifying the **Top 20 teams** based on the total count of **Gold Medals**. A unique historical perspective was gained by counting the number of athletes who competed under banners of **teams that no longer exist** today (e.g., Soviet Union, East Germany). Furthermore, the project drilled down to analyze recent performance, showcasing the **Top 10 athletes** who accumulated the highest number of **Gold Medals in the 21st Century** (games held after the year 2000).

### Specific Focus Analysis

The project concluded with focused analyses on particular demographics and sports. It pinpointed athletes who won any medal at the **London 2012** games. The analysis also highlighted national achievements by identifying the **Top 10 Ukrainian athletes** based on their individual gold medal counts. Finally, a sport-specific query determined the **Top 10 teams** that excelled in a particular discipline, exemplified by the number of gold medals won in **Volleyball**.