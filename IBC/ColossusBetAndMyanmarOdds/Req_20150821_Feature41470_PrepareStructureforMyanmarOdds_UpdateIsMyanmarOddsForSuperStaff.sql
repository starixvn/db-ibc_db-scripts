/*
	Created by: Helen
	Date: 20150904
	Task: commission setting for MO [Redmine #41470]
	DB: DBCust.CustDB - DB06.bodb02

*/ 
-- Run on DBCUST
Use CustDB
GO
DECLARE @CustID INT

SET @CustID = (SELECT custInfo FROM custInfo WITH (NOLOCK) WHERE username = 'STAFF')

UPDATE [dbo].[CustSuper] 
	SET IsMyanmarOdds = 1
WHERE custid = @CustID

GO	
-- Run on DB06
Use bodb02
GO

DECLARE @CustID INT

SET @CustID = (SELECT custInfo FROM custInfo WITH (NOLOCK) WHERE username = 'STAFF')

UPDATE [dbo].[CustSuper] 
	SET IsMyanmarOdds = 1
WHERE custid = @CustID
