-- Data Cleaning 

-- Create a staging table to preserve original data
CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT INTO world_layoffs.layoffs_staging 
SELECT * FROM world_layoffs.layoffs;

-- Identify duplicates
WITH duplicate_cte AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY company, location, industry, total_laid_off,
                   percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
  FROM world_layoffs.layoffs_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1;

-- Create a second staging table with a row_num column to support deletions
CREATE TABLE world_layoffs.layoffs_staging2 (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO world_layoffs.layoffs_staging2
SELECT *,
  ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off,
                 percentage_laid_off, `date`, stage, country, funds_raised_millions
  ) AS row_num
FROM world_layoffs.layoffs_staging;

-- Remove duplicate rows
DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;

-- Standardise text fields
UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);

-- Consolidate inconsistent industry values
UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardise country names
UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Standardise date format
UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Handle missing values

-- Replace empty industry strings with NULL
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate missing industry values using self-join
UPDATE world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Remove rows with no layoff data
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;

-- Final cleanup
ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;

-- Final cleaned table is ready for analysis
SELECT * FROM world_layoffs.layoffs_staging2;
