/*
	Created: Elodie
	Date: 20160301
	Task: Delete redundant All Bet settings except StakeLevel
	DB: DBCust/CustDB
*/
DECLARE @maxcustID1 INT = xxx, @maxcustID2 INT = xxx
DECLARE @Sporttype INT, @Bettype INT, @IsLive BIT

SELECT @Sporttype = 211, @Bettype = 2401, @IsLive = 0

--PT
DELETE cs
FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive
	
	
DELETE cs
FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive

DELETE cs
FROM [dbo].CustPTGroupSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive

--Commission
DELETE cs
FROM [dbo].CustDiscount3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

DELETE cs
FROM [dbo].CustDiscount3rd_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

--WinLossLimit
DELETE cs
FROM [dbo].CustWinLossLimit_Agent cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

DELETE cs
FROM [dbo].CustWinLossLimit_Member cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID2
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
