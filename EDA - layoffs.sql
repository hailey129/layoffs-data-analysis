-- Exploratory Data Analysis

SELECT * FROM world_layoffs.layoffs_staging2;

-- Maximum layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM world_layoffs.layoffs_staging2;

-- 100% layoff cases
SELECT * 
FROM world_layoffs.layoffs_staging2 
WHERE percentage_laid_off = 1 
ORDER BY total_laid_off DESC;

-- High funding companies with full layoffs
SELECT * 
FROM world_layoffs.layoffs_staging2 
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- Total laid off by company
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- Date range
SELECT MIN(`date`), MAX(`date`) FROM world_layoffs.layoffs_staging2;

-- Total layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Total layoffs by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- Total layoffs by date
SELECT `date`, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY `date`
ORDER BY total_laid_off DESC;

-- Total layoffs by year
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY year
ORDER BY total_laid_off DESC;

-- Total layoffs by funding stage
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- Average percentage laid off by country
SELECT country, AVG(percentage_laid_off) AS avg_pct_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY avg_pct_laid_off DESC;

-- Total layoffs by month
SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY month
ORDER BY month ASC;

-- Rolling total of layoffs
WITH Rolling_Total AS (
  SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS total_off
  FROM world_layoffs.layoffs_staging2
  WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
  GROUP BY month
)
SELECT month, total_off, 
       SUM(total_off) OVER (ORDER BY month) AS rolling_total
FROM Rolling_Total;

-- Layoffs by company and year
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY company, year
ORDER BY total_laid_off DESC;

-- Top 5 companies per year by layoffs
WITH Company_Year (company, year, total_laid_off) AS (
  SELECT company, YEAR(`date`), SUM(total_laid_off)
  FROM world_layoffs.layoffs_staging2
  GROUP BY company, YEAR(`date`)
),
Ranked AS (
  SELECT *, 
         DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
  WHERE year IS NOT NULL
)
SELECT * 
FROM Ranked
WHERE ranking <= 5;
