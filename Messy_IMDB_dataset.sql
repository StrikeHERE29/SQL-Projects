--Dataset: Messy IMDB dataset
-- Source: https://www.kaggle.com/datasets/davidfuenteherraiz/messy-imdb-dataset
-- Queried using: MS SQL

--Checking for NULL/empty values in titleID column

SELECT TITLEID
FROM messy_IMDB_dataset
WHERE titleID LIKE NULL OR titleID LIKE '' OR titleID LIKE ' '

--We delete the value because it was empty in all columns.

DELETE FROM messy_IMDB_dataset WHERE titleID LIKE NULL OR titleID LIKE '' OR titleID LIKE ' '

-- Checking for duplicate values 

SELECT TITLEID, COUNT(*)
FROM messy_IMDB_dataset
GROUP BY titleID
HAVING COUNT(*) > 1

--Checking for special characters

SELECT titleID
FROM messy_IMDB_dataset
WHERE titleID  LIKE '%[^a-zA-Z0-9]%'

--Checking for white spaces

UPDATE messy_IMDB_dataset
SET titleID = LTRIM(RTRIM(TITLEID))

UPDATE messy_IMDB_dataset
SET titleID = REPLACE(TITLEID,' ','')


--NEXT COLUMN: Original title

--Checking for NULL/empty values in ORIGINAL TITLE column

SELECT [Original title]
FROM messy_IMDB_dataset
WHERE [Original title] LIKE NULL OR [Original title] LIKE '' OR [Original title] LIKE ' '

--Checking for duplicate values

SELECT [ORIGINAL TITLE], COUNT(*) 
FROM messy_IMDB_dataset
GROUP BY [Original title]
HAVING COUNT(*) > 1

--Checking for special characters

SELECT messy_IMDB_dataset.[Original title]
FROM messy_IMDB_dataset
WHERE [Original title] LIKE '%[^a-zA-Z0-9:, ''-.\?!&()/]%' OR [Original title] LIKE '%[ĂÂÎȘȚăâîșț]%'

--We update the result of the previous query to N/A because we don't understand the title name

UPDATE messy_IMDB_dataset
SET [Original title] = 'N/A'
WHERE [Original title] LIKE '%[^a-zA-Z0-9:, ''-.\?!&()/]%' OR [Original title] LIKE '%[ĂÂÎȘȚăâîșț]%'

--Checking for white spaces

UPDATE messy_IMDB_dataset
SET [Original title] = LTRIM(RTRIM([ORIGINAL TITLE]));

--Next COLUMN: Release year

SELECT [RELEASE YEAR]
FROM messy_IMDB_dataset


SELECT [RELEASE YEAR]
FROM messy_IMDB_dataset
WHERE [Release year] LIKE '% %'

--Checking for positioning values 
SELECT [RELEASE YEAR]
FROM messy_IMDB_dataset
WHERE [Release year] LIKE '%st%' 
   OR [Release year] LIKE '%ST%' 
   OR [Release year] LIKE '%nd%' 
   OR [Release year] LIKE '%ND%' 
   OR [Release year] LIKE '%rd%' 
   OR [Release year] LIKE '%RD%' 
   OR [Release year] LIKE '%th%' 
   OR [Release year] LIKE '%TH%' 
   OR [Release year] LIKE '%of%' 
   OR [Release year] LIKE '%OF%'
   or [Release year] LIKE '%The%';


   BEGIN TRANSACTION;

   UPDATE messy_IMDB_dataset
   SET [Release year] = REPLACE([RELEASE YEAR], 'rd','')
   WHERE [Release year] LIKE '%rd%'

   COMMIT


   BEGIN TRANSACTION;

   UPDATE messy_IMDB_dataset
   SET [Release year] = REPLACE([RELEASE YEAR], 'of','')
   WHERE [Release year] LIKE '%of%'

   COMMIT


   UPDATE messy_IMDB_dataset
   SET [Release year] = REPLACE([RELEASE YEAR], 'The','')
   WHERE [Release year] LIKE '%The%'

   UPDATE messy_IMDB_dataset
   SET [Release year] = REPLACE([RELEASE YEAR], 'th','')
   WHERE [Release year] LIKE '%th%'

    UPDATE messy_IMDB_dataset
   SET [Release year] = REPLACE([RELEASE YEAR], ',','')
   WHERE [Release year] LIKE '%,%'

  -- Checking for the right format

   SELECT [RELEASE YEAR]
FROM [messy_IMDB_dataset]
WHERE PATINDEX('%[january|february|march|april|may|june|july|august|september|october|november|december|jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec]%', [Release year]) > 0;

UPDATE messy_IMDB_dataset
SET [Release year] = REPLACE([RELEASE YEAR], 'December', '12')

UPDATE messy_IMDB_dataset
SET [Release year] = REPLACE([Release year], 'Feb', '02')


UPDATE messy_IMDB_dataset
SET [Release year] = REPLACE([RELEASE YEAR], 'marzo', '03')


begin transaction
UPDATE messy_IMDB_dataset
SET [Release year] = REPLACE([Release year], 'year', '')

COMMIT

--Separating DD-YY-MM WITH -

UPDATE messy_IMDB_dataset
SET [Release year] = REPLACE([RELEASE YEAR],' ','-')
WHERE [Release year] LIKE '% %'

-- We have some duplicate - values so we need to replace them
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET [Release year] = REPLACE([RELEASE YEAR], '--', '-')
WHERE [Release year] LIKE '%--%'
commit
-- We have white spaces in front and at the end of the date so we need to remove them

BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET [Release year] = LTRIM(RTRIM([Release year]));

COMMIT


--Checking for unconvertable values
SELECT [RELEASE YEAR]
FROM [messy_IMDB_dataset]
WHERE TRY_CONVERT(DATE, [Release year], 105) IS NULL;




--We have dd values formed by 1 digit so we need to update it to 2 digits (6-> 06)
SELECT [RELEASE YEAR]
FROM messy_IMDB_dataset
WHERE SUBSTRING([RELEASE YEAR], 1, 2) LIKE '%-'

SELECT [RELEASE YEAR],
CASE
	WHEN SUBSTRING([RELEASE YEAR], 1, 2) LIKE '%-' THEN CONCAT('0', [RELEASE YEAR])
	ELSE [RELEASE YEAR]
	END AS RELEASE_YEAR
FROM messy_IMDB_dataset

BEGIN TRANSACTION 

UPDATE messy_IMDB_dataset
SET [Release year] =
	CASE	
		WHEN SUBSTRING([RELEASE YEAR], 1, 2) LIKE '%-' THEN CONCAT('0', [RELEASE YEAR])
		ELSE [Release year]
		END;

		COMMIT

--Checking for different date formats
SELECT [Release year]
FROM messy_IMDB_dataset
WHERE [Release year] LIKE '____-__-__'  -- yyyy-mm-dd
   OR [Release year] LIKE '__-__-____' -- dd-mm-yyyy
   OR [Release year] LIKE '__-__-__';  --dd-mm-yy

   -- Updating to only one date format and modify the yy into yyyy
   SELECT [Release year],
  CASE
    WHEN [Release year] LIKE '____-__-__' THEN CONCAT(
      SUBSTRING([Release year], 9, 2), '-',
      SUBSTRING([Release year], 6, 2), '-',
      SUBSTRING([Release year], 1, 4)
    )
    WHEN [Release year] LIKE '__-__-__' THEN CONCAT(
      SUBSTRING([Release year], 1, 6),
      CASE
        WHEN CAST(SUBSTRING([Release year], 7, 2) AS INT) < 50 THEN '20'
        ELSE '19'
      END,
      SUBSTRING([Release year], 7, 2)
    )
    ELSE [Release year]
  END AS NewReleaseYear
FROM messy_IMDB_dataset;


BEGIN TRANSACTION

UPDATE messy_IMDB_dataset
SET [Release year] = 
		CASE
			WHEN [Release year] LIKE '____-__-__' THEN CONCAT(
			SUBSTRING([RELEASE YEAR], 9, 2), '-',
			SUBSTRING([RELEASE YEAR], 6, 2), '-',
			SUBSTRING([RELEASE YEAR], 1, 4)
			)
			WHEN [Release year] LIKE '__-__-__' THEN CONCAT(
			SUBSTRING([RELEASE YEAR], 1, 6),
			CASE
				WHEN CAST(SUBSTRING([RELEASE YEAR], 7, 2) AS INT) < 50 THEN '20'
				ELSE '19'
				END,
				SUBSTRING([RELEASE YEAR], 7, 2)
				) ELSE [Release year]
				END
				FROM messy_IMDB_dataset

				COMMIT

-- Checking for invalid DD values
SELECT [RELEASE YEAR]
FROM messy_IMDB_dataset
WHERE CAST(SUBSTRING([RELEASE YEAR], 1,2) AS INT) >31


BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET [Release year] = 'N/A'
WHERE CAST(SUBSTRING([RELEASE YEAR], 1,2) AS INT) > 31
COMMIT

---- Checking for invalid MM values
SELECT [RELEASE YEAR]
FROM messy_IMDB_dataset
WHERE CAST(SUBSTRING([RELEASE YEAR], 4,2) AS INT) >12

BEGIN TRANSACTION 
UPDATE messy_IMDB_dataset
SET [Release year] = 'N/A'
WHERE CAST(SUBSTRING([RELEASE YEAR], 4, 2)AS INT) > 12
COMMIT

UPDATE messy_IMDB_dataset
SET [Release year] = TRY_CONVERT(DATE, [RELEASE YEAR], 105);


--Deleting the null values
UPDATE messy_IMDB_dataset
SET [Release year] = 'N/A'
WHERE [Release year] IS NULL

--Next COLUMN: Genre

SELECT GENRE
FROM messy_IMDB_dataset

--Checking for NULL/empty values

SELECT GENRE
FROM messy_IMDB_dataset
WHERE GENRE IS NULL OR GENRE LIKE '' OR GENRE LIKE ' ' 

--Checking for special characters
SELECT GENRE
FROM messy_IMDB_dataset
WHERE GENRE LIKE '%[^a-zA-Z0-9:, ''-.\?!&()/]%' OR GENRE LIKE '%[ĂÂÎȘȚăâîșț]%'

--Removing white spaces
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET GENRE = LTRIM(RTRIM(GENRE));

COMMIT


--Next COLUMN: Duration

SELECT DURATION
FROM messy_IMDB_dataset

--Checking for NULL values

SELECT DURATION
FROM messy_IMDB_dataset
WHERE DURATION IS NULL OR DURATION LIKE ' ' OR DURATION LIKE ''

UPDATE messy_IMDB_dataset
SET DURATION = 'N/A'
WHERE DURATION IS NULL OR DURATION LIKE ' ' OR DURATION LIKE ''

--Checking for special characters
--Duration COLUMN should only have numeric values

SELECT DURATION
FROM messy_IMDB_dataset
WHERE DURATION LIKE'%[^0-9]%'

BEGIN TRANSACTION 
UPDATE messy_IMDB_dataset
SET Duration = 'N/A'
WHERE DURATION LIKE '%[^0-9]%'
COMMIT

-- We can't convert N/A to int so we make the values null
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET Duration = NULL
WHERE DURATION LIKE 'N/A'
COMMIT

--Converting to INT
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET DURATION = 
	CASE
		WHEN TRY_CAST(DURATION AS INT) IS NOT NULL THEN CAST(DURATION AS INT)
		ELSE NULL
		END
		COMMIT

ALTER TABLE MESSY_IMDB_DATASET
ALTER COLUMN DURATION INT

--Next COLUMN: Country

SELECT COUNTRY 
FROM messy_IMDB_dataset

--Checking for NULL values
SELECT COUNTRY
FROM messy_IMDB_dataset
WHERE Country IS NULL OR COUNTRY LIKE ' ' OR COUNTRY LIKE ''

--Checking for numerical or special characters
SELECT COUNTRY
FROM messy_IMDB_dataset
WHERE COUNTRY LIKE '%[^a-zA-Z ]%'

UPDATE messy_IMDB_dataset
SET COUNTRY = REPLACE(COUNTRY,'.','')
WHERE COUNTRY LIKE '%[^a-zA-Z ]%'



UPDATE messy_IMDB_dataset
SET COUNTRY = LTRIM(RTRIM(COUNTRY))

BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET Country = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(COUNTRY, '0', ''), '1', ''), '2', ''), '3', ''), '4', ''), '5', ''), '6', ''), '7', ''), '8', ''), '9', '')
COMMIT

--Modifying the US to USA
SELECT COUNTRY
FROM messy_IMDB_dataset
WHERE COUNTRY LIKE 'US'

BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET COUNTRY = CONCAT('US', 'A')
WHERE COUNTRY LIKE 'US'
COMMIT

--Corect the misspelled from Zealand
SELECT COUNTRY
FROM messy_IMDB_dataset
WHERE COUNTRY LIKE '%LAND%'


BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET Country = REPLACE(REPLACE(COUNTRY, 'Zesland', 'Zealand'), 'Zeland', 'Zealand')
WHERE COUNTRY LIKE '%ZESLAND%' OR COUNTRY LIKE '%ZELAND%';

commit


--Next COLUMN: Content Rating 

SELECT [CONTENT RATING]
FROM messy_IMDB_dataset

--Check for null/empty values

SELECT [Content Rating]
FROM messy_IMDB_dataset
WHERE [Content Rating] IS NULL OR [Content Rating] LIKE ' ' OR [Content Rating] LIKE ''

--Delete white spaces

UPDATE messy_IMDB_dataset
SET [Content Rating] = LTRIM(RTRIM([Content Rating]))


--Checking for special characters

SELECT [CONTENT RATING]
FROM messy_IMDB_dataset
WHERE [Content Rating] LIKE '%[^A-Za-z0-9 -]%'

--Removing # from N/A
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET [Content Rating] = REPLACE([CONTENT RATING], '#N/A', 'N/A')
WHERE [Content Rating] LIKE '%#%'

COMMIT


--We know that only the below values are approved for ratings so we check to see if there are any other values
SELECT [CONTENT RATING]
FROM messy_IMDB_dataset
WHERE [Content Rating] NOT IN ('G','PG','PG-13','R','NC-17','NR')


UPDATE messy_IMDB_dataset
SET [Content Rating] = REPLACE([Content Rating], 'Not Rated', 'NR')
WHERE [Content Rating] LIKE 'NOT RATED'

BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET [Content Rating] = 'N/A'
WHERE [Content Rating] NOT IN ('G','PG','PG-13','R','NC-17','NR')

--Next COLUMN: Director

SELECT DIRECTOR
FROM messy_IMDB_dataset


--Check for null/empty values

SELECT DIRECTOR 
FROM messy_IMDB_dataset
WHERE Director IS NULL OR Director LIKE ' ' OR Director LIKE ''

--Check for white spaces

UPDATE messy_IMDB_dataset
SET Director = LTRIM(RTRIM(DIRECTOR))

--Check for special characters
--Director column should only contain letters and - values

SELECT DIRECTOR
FROM messy_IMDB_dataset
WHERE Director LIKE '%[^A-Za-z -]%'

SELECT LEFT(DIRECTOR, CHARINDEX(',', DIRECTOR) -1) AS EXTRACTEDTEXT
FROM messy_IMDB_dataset
WHERE CHARINDEX(',',DIRECTOR) > 0

BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET DIRECTOR = LEFT(DIRECTOR, CHARINDEX(',', DIRECTOR)-1)
WHERE CHARINDEX(',', DIRECTOR) > 0


--Next COLUMN: Column 8
--Check for NULL/empty values

SELECT [COLUMN 8]
FROM messy_IMDB_dataset
WHERE [Column 8] IS NULL OR [Column 8] LIKE ' ' OR [Column 8] LIKE ''

--All values from column 8 are empty so we delete column 8

ALTER TABLE MESSY_IMDB_DATASET
DROP COLUMN [COLUMN 8]

--Next COLUMN: Income

SELECT INCOME
FROM messy_IMDB_dataset

--Check for NULL/empty values

SELECT INCOME 
FROM messy_IMDB_dataset
WHERE INCOME IS NULL OR INCOME LIKE ' ' OR INCOME LIKE ''

--Check for white spaces
UPDATE messy_IMDB_dataset
SET INCOME = LTRIM(RTRIM(INCOME))

--Check for special /non-numeric characters

SELECT INCOME
FROM messy_IMDB_dataset
WHERE INCOME LIKE '%[^0-9]%'

UPDATE messy_IMDB_dataset
SET Income = REPLACE(INCOME,'$','')

UPDATE messy_IMDB_dataset
SET Income = REPLACE(INCOME,'O','0')

UPDATE messy_IMDB_dataset
SET INCOME = REPLACE(INCOME,'.','')

UPDATE messy_IMDB_dataset
SET INCOME = REPLACE(INCOME,',','')


--Changed the data type to float
ALTER TABLE MESSY_IMDB_DATASET
ALTER COLUMN INCOME FLOAT NOT NULL

--Next COLUMN: Votes

SELECT VOTES
FROM messy_IMDB_dataset

--Check for NULL/empty values

SELECT VOTES
FROM messy_IMDB_dataset
WHERE VOTES IS NULL OR VOTES LIKE ' ' OR VOTES LIKE ''

--Check for white spaces

UPDATE messy_IMDB_dataset
SET VOTES = LTRIM(RTRIM(VOTES))

--Check for special/ non numeric characters

SELECT VOTES
FROM messy_IMDB_dataset
WHERE VOTES LIKE '%[^0-9]%'

--Removing . values 
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET VOTES = REPLACE(VOTES,'.','')
COMMIT

--Changed the data type
ALTER TABLE MESSY_IMDB_DATASET
ALTER COLUMN VOTES INT NOT NULL


--Next COLUMN: Score
SELECT SCORE
FROM messy_IMDB_dataset


--Check for NULL/empty values

SELECT SCORE 
FROM messy_IMDB_dataset
WHERE SCORE IS NULL OR SCORE LIKE ' ' OR SCORE LIKE ''

--Check for special/non-numeric characters

SELECT SCORE
FROM messy_IMDB_dataset
WHERE SCORE LIKE '%[^0-9 .]%'


--Removing white spaces
UPDATE messy_IMDB_dataset
SET SCORE = LTRIM(RTRIM(SCORE))

--We have prefix values of 0 AND + so we need to remove them
SELECT SUBSTRING(SCORE,1,1)
FROM messy_IMDB_dataset

BEGIN TRANSACTION 
UPDATE messy_IMDB_dataset
SET SCORE = 
	CASE
		WHEN SUBSTRING(SCORE,1,1) = '0' THEN RIGHT(SCORE, LEN(SCORE) - 1)
		ELSE SCORE
		END
	COMMIT

BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET SCORE = REPLACE(SCORE,'+','')
COMMIT

UPDATE messy_IMDB_dataset
SET SCORE = REPLACE(SCORE,':','.')

--We extract just the first 3 characters 
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET SCORE = SUBSTRING(SCORE,1,3)
COMMIT

--We have , values instead of . so we need to modify them
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET SCORE = REPLACE(SCORE,',','.')
COMMIT


--After we extracted the first 3 characters, some values included multiple dots. So we remove them
BEGIN TRANSACTION
UPDATE messy_IMDB_dataset
SET SCORE = 
CASE
	WHEN RIGHT(SCORE,1) = '.' THEN REPLACE(SCORE,'.','')
	ELSE SCORE
	END
	COMMIT
	
	--Modify the data type

	ALTER TABLE MESSY_IMDB_DATASET
	ALTER COLUMN SCORE FLOAT NOT NULL

