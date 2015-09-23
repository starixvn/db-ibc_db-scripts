/*
	Created by: Helen
	Date: 20150904
	Task: commission setting for MO [Redmine #41470]
	DB: DBCust.CustDB 

*/ 
-- Run on DBCUST
Use CustDB
GO
DECLARE @CustID INT

SET @CustID = (SELECT custInfo FROM custInfo WITH (NOLOCK) WHERE username = 'STAFF')

UPDATE [dbo].[CustSuper] 
	SET IsMyanmarOdds = 1
WHERE custid = @CustID
