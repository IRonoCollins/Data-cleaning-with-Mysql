-- Load the raw data for initial inspection
SELECT * 
FROM layoffs;

-- Step 1: Creating a Staging Table
-- It is important to maintain the raw data for safety, so we create a staging table
CREATE TABLE layoffs_staging 
LIKE layoffs;

-- Verify the structure of the new table
SELECT * 
FROM layoffs_staging;

-- Insert all data from the original table into the staging table
INSERT INTO layoffs_staging 
SELECT * 
FROM layoffs;

-- Step 2: Removing Duplicates
-- Identify duplicate rows using ROW_NUMBER().Create a CTE
WITH duplicate_row AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
                                         percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
SELECT * 
FROM duplicate_row 
WHERE row_num > 1;

-- Step 3: Creating a New Staging Table with row_num Column
CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
);

-- Insert data into the new staging table with row numbers for duplicates
INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
                                     percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Disable safe mode to allow deletions
SET SQL_SAFE_UPDATES = 0;

-- Remove duplicate rows (keep only row_num = 1)
DELETE 
FROM layoffs_staging2 
WHERE row_num > 1;

-- Step 4: Standardizing Data
-- Trim whitespace from company names
UPDATE layoffs_staging2 
SET company = TRIM(company);

-- Standardize industry names (e.g., merging similar values)
UPDATE layoffs_staging2 
SET industry = 'crypto' 
WHERE industry LIKE 'crypto%';

-- Standardize country names (removing trailing periods)
UPDATE layoffs_staging2 
SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%';

-- Step 5: Converting Date Format
-- Convert date column from text to proper DATE format
UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

-- Step 6: Handling Missing Values
-- Set empty industry values to NULL
UPDATE layoffs_staging2 
SET industry = NULL 
WHERE industry = '';

-- Fill missing industry values by using industry data from the same company
UPDATE layoffs_staging2 l1
JOIN layoffs_staging2 l2 
	ON l1.company = l2.company
SET l1.industry = l2.industry
WHERE l1.industry IS NULL AND l2.industry IS NOT NULL;

-- Step 7: Deleting Irrelevant Data
-- Remove rows where both total_laid_off and percentage_laid_off are NULL
DELETE 
FROM layoffs_staging2 
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Drop the row_num column as it is no longer needed
ALTER TABLE layoffs_staging2 
DROP COLUMN row_num;

-- Final Check: View the cleaned dataset
SELECT * 
FROM layoffs_staging2;
