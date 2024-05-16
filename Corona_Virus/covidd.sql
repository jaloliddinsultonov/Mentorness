-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values
SELECT * FROM corona
WHERE province IS NULL OR
'Country/Region' IS NULL OR
latitude IS NULL OR
longitude IS NULL OR
date IS NULL OR
confirmed IS NULL OR
deaths IS NULL OR
recovered IS NULL
	
--Q2. If NULL values are present, update them with zeros for all columns. 
UPDATE corona
SET
	province = COALESCE(province, ''), 
	"Country/Region" = COALESCE('Country/Region', ''),
	latitude = COALESCE(latitude, 0),
	longitude = COALESCE(longitude, 0),
	date = COALESCE(date, ''),
	confirmed = COALESCE(confirmed, 0),
	deaths = COALESCE(deaths, 0),
	recovered = COALESCE(recovered, 0)
WHERE
	'Country/Region' IS NULL OR
	latitude IS NULL OR
	longitude IS NULL OR
	date IS NULL OR
	confirmed IS NULL OR
	deaths IS NULL OR
	recovered IS NULL;

-- Q3. check total number of rows
SELECT COUNT(*) FROM corona
	
-- Q4. Check what is start_date and end_date
SELECT MIN(CAST(date AS DATE)) AS start_date,
MAX(CAST(date AS DATE)) AS end_date
FROM corona;

-- Q5. Number of month present in dataset
SELECT 
	COUNT(DISTINCT EXTRACT(YEAR FROM CAST(date AS DATE)) || '-' || EXTRACT(MONTH FROM CAST(date AS DATE)))
	AS num_months
FROM corona;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    EXTRACT(YEAR FROM CAST(date AS DATE)) AS year,
    EXTRACT(MONTH FROM CAST(date AS DATE)) AS month,
    AVG(confirmed) AS avg_confirmed,
    AVG(deaths) AS avg_deaths,
    AVG(recovered) AS avg_recovered
FROM 
    corona
GROUP BY 
    EXTRACT(YEAR FROM CAST(date AS DATE)),
	EXTRACT(MONTH FROM CAST(date AS DATE))
ORDER BY 
    year, month;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
    EXTRACT(YEAR FROM CAST(date AS DATE)) AS year,
    EXTRACT(MONTH FROM CAST(date AS DATE)) AS month,
    (SELECT confirmed 
     FROM corona 
     WHERE EXTRACT(YEAR FROM CAST(date AS DATE)) = EXTRACT(YEAR FROM CAST(corona.date AS DATE)) 
       AND EXTRACT(MONTH FROM CAST(date AS DATE)) = EXTRACT(MONTH FROM CAST(corona.date AS DATE)) 
     GROUP BY confirmed 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS most_frequent_confirmed,
    (SELECT deaths 
     FROM corona 
     WHERE EXTRACT(YEAR FROM CAST(date AS DATE)) = EXTRACT(YEAR FROM CAST(corona.date AS DATE)) 
       AND EXTRACT(MONTH FROM CAST(date AS DATE)) = EXTRACT(MONTH FROM CAST(corona.date AS DATE)) 
     GROUP BY deaths 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS most_frequent_deaths,
    (SELECT recovered 
     FROM corona 
     WHERE EXTRACT(YEAR FROM CAST(date AS DATE)) = EXTRACT(YEAR FROM CAST(corona.date AS DATE)) 
       AND EXTRACT(MONTH FROM CAST(date AS DATE)) = EXTRACT(MONTH FROM CAST(corona.date AS DATE)) 
     GROUP BY recovered 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS most_frequent_recovered
FROM 
    corona
GROUP BY 
    EXTRACT(YEAR FROM CAST(date AS DATE)), EXTRACT(MONTH FROM CAST(date AS DATE))
ORDER BY 
    year, month;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM CAST(date AS DATE)) AS year,
    MIN(confirmed) AS min_confirmed,
    MIN(deaths) AS min_deaths,
    MIN(recovered) AS min_recovered
FROM 
    corona
GROUP BY 
    EXTRACT(YEAR FROM CAST(date AS DATE))
ORDER BY 
    year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM CAST(date AS DATE)) AS year,
    MAX(confirmed) AS max_confirmed,
    MAX(deaths) AS max_deaths,
    MAX(recovered) AS max_recovered
FROM 
    corona
GROUP BY 
    EXTRACT(YEAR FROM CAST(date AS DATE))
ORDER BY 
    year;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    EXTRACT(YEAR FROM CAST(date AS DATE)) AS year,
    EXTRACT(MONTH FROM CAST(date AS DATE)) AS month,
    AVG(confirmed) AS total_confirmed,
    AVG(deaths) AS total_deaths,
    AVG(recovered) AS total_recovered
FROM 
    corona
GROUP BY 
    EXTRACT(YEAR FROM CAST(date AS DATE)),
	EXTRACT(MONTH FROM CAST(date AS DATE))
ORDER BY 
    year, month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    total_confirmed_cases,
    average_confirmed_cases,
    variance_confirmed_cases,
    SQRT(variance_confirmed_cases) AS stdev_confirmed_cases
FROM (
    SELECT 
        (SELECT SUM(confirmed) FROM corona) AS total_confirmed_cases,
        (SELECT AVG(confirmed) FROM corona) AS average_confirmed_cases,
        (SELECT VARIANCE(confirmed) FROM corona) AS variance_confirmed_cases
) AS results;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    total_deaths_cases,
    average_deaths_cases,
    variance_deaths_cases,
    SQRT(variance_deaths_cases) AS stdev_deaths_cases
FROM (
    SELECT 
        (SELECT SUM(deaths) FROM corona) AS total_deaths_cases,
        (SELECT AVG(deaths) FROM corona) AS average_deaths_cases,
        (SELECT VARIANCE(confirmed) FROM corona) AS variance_deaths_cases
) AS results;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    total_recovered_cases,
    average_recovered_cases,
    variance_recovered_cases,
    SQRT(variance_recovered_cases) AS stdev_recovered_cases
FROM (
    SELECT 
        (SELECT SUM(recovered) FROM corona) AS total_recovered_cases,
        (SELECT AVG(recovered) FROM corona) AS average_recovered_cases,
        (SELECT VARIANCE(recovered) FROM corona) AS variance_recovered_cases
) AS results;

-- Q14. Find Country having highest number of the Confirmed case
SELECT "Country/Region" AS country, SUM(confirmed) AS highest_confirmed_cases
FROM corona
GROUP BY "Country/Region"
ORDER BY highest_confirmed_cases DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT "Country/Region" AS country, SUM(deaths) AS lowest_deaths_cases
FROM corona
GROUP BY "Country/Region"
ORDER BY lowest_deaths_cases DESC
LIMIT 4;

-- Q16. Find top 5 countries having highest recovered case
SELECT "Country/Region" AS country, SUM(recovered) AS highest_recovered_cases
FROM corona
GROUP BY "Country/Region"
ORDER BY highest_recovered_cases DESC
LIMIT 5;
