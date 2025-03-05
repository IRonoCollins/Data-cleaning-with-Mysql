# 🛠️ Data Cleaning with MySQL  

## 📌 Layoffs Data Cleaning Project  

### 📖 Overview  
This project involves cleaning and standardizing a dataset containing information about company layoffs. The goal is to remove duplicates, handle missing values, standardize text data, and ensure consistency in date formats.  

---

## 🔍 Steps Performed  

### 1️⃣ Creating a Staging Table  
✅ Preserved raw data by creating a `layoffs_staging` table.  
✅ Copied all data from the `layoffs` table into `layoffs_staging`.  

### 2️⃣ Removing Duplicates  
✅ Identified duplicate rows using `ROW_NUMBER()` with `PARTITION BY`.  
✅ Created `layoffs_staging2` to store cleaned data with a `row_num` column.  
✅ Deleted duplicate rows where `row_num > 1`.  

### 3️⃣ Standardizing Data  
✅ Trimmed whitespace from company names.  
✅ Standardized industry names (e.g., merging variations of **'crypto'**).  
✅ Removed trailing periods from country names.  

### 4️⃣ Converting Date Format  
✅ Used `STR_TO_DATE()` to convert date values from text to `DATE` format.  
✅ Modified the `date` column type to `DATE`.  

### 5️⃣ Handling Missing Values  
✅ Replaced empty industry values with `NULL`.  
✅ Used `JOIN` to fill missing industries based on the same company.  

### 6️⃣ Deleting Irrelevant Data  
✅ Removed rows where both `total_laid_off` and `percentage_laid_off` were `NULL`.  
✅ Dropped the `row_num` column as it was no longer needed.  

---

## 📊 Final Output  
✔️ The cleaned dataset is stored in `layoffs_staging2`.  
✔️ All transformations ensure a standardized and structured dataset.  

---

## 🛠️ Technologies Used  
- MySQL  
- SQL Query Optimization Techniques  

---

## 🚀 Usage  
🔹 Run the SQL script in a MySQL environment.  
🔹 The cleaned dataset can be used for further analysis and reporting.  

**ℹ️ Source**
*Alexthedataanalyst youtube training *[find it here(https://www.youtube.com/channel/UC7cs8q-gJRlGwj4A8OmCmXg)]
