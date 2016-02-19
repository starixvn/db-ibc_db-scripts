/*
	Created: Dominic
	Date: 2016-02-26
	Task: Delete unexpected CF setting of customers having custid > @maxcustID
	DB: DBCust.CustDB
*/ 
DECLARE @maxcustID INT = xxx

--PT
DELETE cs
FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
		AND cs.Sporttype = 206
		AND cs.Bettype = 1003
		AND cs.IsLive = 0
	
	
DELETE cs
FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
		AND cs.Sporttype = 206
		AND cs.Bettype = 1003
		AND cs.IsLive = 0

DELETE cs
FROM [dbo].CustPTGroupSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.Sporttype = 206
		AND cs.Bettype = 1003
		AND cs.IsLive = 0

--Bet Limit	
DELETE cs
FROM [dbo].CustBetSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
		AND cs.Sporttype = 206
		AND cs.Bettype = 1003

DELETE cs
FROM [dbo].CustBetSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
		AND cs.Sporttype = 206
		AND cs.Bettype = 1003
		
--Commission
DELETE cs
FROM [dbo].CustDiscount3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
		AND cs.Sporttype = 206
		AND cs.Bettype = 1003

DELETE cs
FROM [dbo].CustDiscount3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
		AND cs.Sporttype = 206
		AND cs.Bettype = 1003

