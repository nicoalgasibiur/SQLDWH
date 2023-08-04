
-- Create the table.
CREATE TABLE dbo.DIM_Time (
    Time_Key INTEGER PRIMARY KEY NOT NULL,
	Date DATE NOT NULL,
	Period VARCHAR NOT NULL,
	Year INTEGER NOT NULL,
	Month CHAR(2) NOT NULL,
	Day CHAR(2) NOT NULL,
	Semester VARCHAR(12) NOT NULL
);


-- Clean the table for the new execution.
TRUNCATE TABLE dbo.DIM_Time

-- Declare parameters 
DECLARE @Startdate DATE,
        @EndDate DATE

-- Input a value for the start point.
SET @Startdate = '2000-01-01'
SET @EndDate = GETDATE()

-- Loop condition
WHILE @Startdate <= @EndDate
BEGIN
	-- Insert new record
	INSERT INTO dbo.DIM_Time ( [Time_Key]
							  ,[Date]
							  ,[Period]
							  ,[Year]
							  ,[Month]
							  ,[Day]
							  ,[Semester]
							  )
							  
	SELECT  CONVERT(VARCHAR,@StartDate, 112),
			@Startdate,
			CAST(YEAR(@Startdate)AS VARCHAR(4))+'-'+RIGHT('0'+CAST(MONTH(@Startdate)AS VARCHAR(2)),2),
			YEAR(@Startdate), 
			RIGHT('0'+CAST(MONTH(@Startdate)AS VARCHAR(2)),2),
			RIGHT('0'+CAST(CAST(DAY(@Startdate) AS VARCHAR(2))AS VARCHAR(2)),2),
			CASE 
				WHEN MONTH(@StartDate) < 7 THEN '1er Semestre'
				ELSE '2do Semestre'
			END 
    -- Add 1 day to get the new value for the next record.
	SET @Startdate = DATEADD(DAY, 1, @Startdate)

END
	
