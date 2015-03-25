--1. create table Transactions_Staging
-- 2. extract data that we will archive to this table
-- 3. delete data in Transactions table
--4. bulk import to FPS_SUB_ARCHIVE
--5. truncate Staging table

/*
SELECT MIN(TransDate)
FROM Transactions WITH (NOLOCK) 
*/

/*
--copy to staging  table
insert into Transactions_Staging
select  *--count(1)
from Transactions T WITH (NOLOCK) 
WHERE TransDate >= '2012-12-01'
and TransDate < '2013-01-01'
*/

/*
--delete ONE TIME
	DELETE Transactions WITH (ROWLOCK) 
	WHERE TransDate >= '2012-12-01'
	and TransDate < '2013-01-01'

*/
/*
--delete by batch
SET NOCOUNT ON;
 
DECLARE @r INT;
 
SET @r = 1;
 
WHILE @r > 0
BEGIN
  BEGIN TRANSACTION;
 
  DELETE TOP (100000) -- this will change
    dbo.Transactions
  WHERE TransDate >= '2012-12-01'
	and TransDate < '2013-01-01'
 
  SET @r = @@ROWCOUNT;
 
  COMMIT TRANSACTION;   
END
*/

--truncate table Transactions_Staging