# **Layoffs Analysis (2020–2023) — Global Tech Trends** 📉 
Note: This project was completed for educational and portfolio purposes. The data was sourced from publicly available datasets, and all analysis was performed using MySQL and SQL-based exploratory technique

# **Introduction**

This project explores the widespread layoffs that occurred across various industries between 2020 and 2023, with a particular focus on the tech sector. By leveraging SQL for data cleaning and exploratory data analysis (EDA), the goal is to uncover patterns in layoffs by company, country, year, industry, and company growth stage.

This analysis was inspired by a broader interest in understanding the economic ripple effects of global events—particularly the pandemic, and how data can reveal both short-term shocks and long-term trends in employment.

# **Dataset Overview**

The dataset contains publicly tracked records of global layoffs from 2020 to 2023 and includes:

1. Company name

2. Location and country

3. Industry

4. Number of employees laid off

5. Percentage of company laid off

6. Date of announcement

7. Company stage (e.g., post-IPO, Series C, etc.)

8. Funds raised (in millions)

# **Business/Analytical Questions**
This project explores key questions such as:

* Which industries and countries were hit the hardest?

* Which companies laid off the most employees each year?

* What months or years saw the highest layoff volume?

* What patterns emerge when observing layoffs by company stage or funding size?

# **Project Goals**
1. Clean and prepare a raw dataset into a usable format

2. Identify and remove duplicate records

3. Conduct EDA to highlight patterns in layoffs

4. Use CTEs, window functions, and aggregation in SQL to produce clear insights

# **Data Cleaning Summary**
* Removed duplicates using ROW_NUMBER() with PARTITION BY

* Standardised inconsistent entries (e.g., "Crypto" vs. "Cryptocurrency")

* Converted date fields from text to proper date format

* Handled missing or null values appropriately

# **Exploratory Data Analysis Highlights**
### 1. Maximum Layoffs  
The highest number of employees laid off in a single event was **12,000**.  
This indicates a major restructuring or downsizing by a large company during turbulent economic conditions.

### 2. 100% Layoffs  
Some companies reported a **100% layoff rate**, signalling complete business shutdowns.  
These cases reflect businesses that were fully dissolved, often startups or firms with limited financial runway.

### 3. Total Layoffs by Company  
The following SQL query identifies companies with the highest cumulative layoffs:

```sql
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
```

### 4. Top Companies with the Highest Layoffs  
Major tech giants reported the highest total layoffs:

- **Meta**, **Amazon**, and **Microsoft** were among the top companies with the most workforce reductions.  
These layoffs were often part of broader cost-cutting strategies following periods of rapid expansion.

### 5. Layoffs by Industry  
Industries most affected by layoffs include:

- **Consumer** and **Retail** sectors, especially during the early stages of the COVID-19 pandemic in 2020.  
- **Tech** and **FinTech** saw significant cuts during the 2022–2023 economic recalibration.

### 6. Layoffs by Year  
Layoff volumes fluctuated over the years, with peaks in:

- **2020**: Driven by the early COVID-19 shock and global lockdowns.  
- **2022–2023**: Marked by economic uncertainty, overhiring corrections, and rising interest rates.

### 7. Rolling Monthly Layoffs  

The following SQL query calculates cumulative monthly layoff totals:

```sql
WITH Rolling_Total AS (
   SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`,
          SUM(total_laid_off) AS total_off
   FROM layoffs_staging2
   GROUP BY `MONTH`
)
SELECT `MONTH`, total_off,
       SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;
```

This reveals long-term cumulative layoff trends and seasonal shifts in workforce reductions.

# **8. Top 5 Companies by Year**
Using SQL window functions like DENSE_RANK(), I identified the top 5 companies each year based on total layoffs.

For example, in 2022, the top companies included Meta, Amazon, Cisco, Peloton, and Carvana.

# **Conclusion**
This project highlights how SQL can be used to extract meaningful insights from real-world layoff data. From identifying industry trends to surfacing company-specific challenges, the analysis supports a broader understanding of workforce dynamics in times of economic change. I approach data analysis not just as a technical task, but as an opportunity to create impact and transform raw information into insights that inform better decisions, improve transparency, and empower business leaders to act with confidence.
