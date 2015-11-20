--Dominic@20151120
--Run at DBCUST.CustDB
DECLARE @maxcustID INT = xxx

--Product Status
DELETE stat
FROM [dbo].[CustProductStatus] stat WITH(UPDLOCK,ROWLOCK)
WHERE stat.CustID > @maxcustID

--PT
DELETE cs
FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	
	
DELETE cs
FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID

DELETE cs
FROM [dbo].CustSettingMode3rd cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID

--Bet Limit	

DELETE cs
FROM [dbo].CustBetSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID

DELETE cs
FROM [dbo].CustBetSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID

