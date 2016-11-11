/*
	Created: Elodie
	Date: 20161010
	Task: Delete redundant NG2 settings 
	DB: DBCust/CustDB
*/
DECLARE @maxcustID INT = xxx

--PT
DELETE cs
FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype BETWEEN 213 AND 218
	
DELETE cs
FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype BETWEEN 213 AND 218

DELETE cs
FROM [dbo].CustPTGroupSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.Sporttype BETWEEN 213 AND 218

--Commission
DELETE cs
FROM [dbo].CustDiscount3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype BETWEEN 213 AND 218


DELETE cs
FROM [dbo].CustDiscount3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype BETWEEN 213 AND 218

--Bet Setting
DELETE cs
FROM [dbo].CustBetSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype BETWEEN 213 AND 218

DELETE cs
FROM [dbo].CustBetSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype BETWEEN 213 AND 218
