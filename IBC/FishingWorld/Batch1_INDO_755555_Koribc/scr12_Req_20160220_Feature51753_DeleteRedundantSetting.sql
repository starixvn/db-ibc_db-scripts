/*
	Created: Helen
	Date: 20161210
	Task: Delete redundant Fishing settings 
	DB: DBCust/CustDB
*/
DECLARE @maxcustID INT = xxx
DECLARE @Sporttype INT, @Bettype INT, @IsLive BIT

SELECT @Sporttype = 219, @Bettype = 1011, @IsLive = 0

--PT
DELETE cs
FROM [dbo].CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON ci.custid = cs.CustID AND ci.srecommend <> 72
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive
	
DELETE cs
FROM [dbo].CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON ci.custid = cs.CustID AND ci.srecommend <> 72
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive

DELETE cs
FROM [dbo].CustPTGroupSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK)
INNER JOIN custInfo CI (NOLOCK) ON CI.custid = cs.AgentID AND CI.srecommend <> 72
WHERE cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype
	AND cs.IsLive = @IsLive

--WinLossLimit
DELETE cs
FROM [dbo].CustWinLossLimit_Agent cs WITH(UPDLOCK,ROWLOCK)
INNER JOIN custInfo CI WITH (NOLOCK) ON ci.custid = cs.CustID AND ci.srecommend <> 72
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype

DELETE cs
FROM [dbo].CustWinLossLimit_Member cs WITH(UPDLOCK,ROWLOCK)
INNER JOIN custInfo CI WITH (NOLOCK) ON ci.custid = cs.CustID AND ci.srecommend <> 72
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype = @Sporttype
	AND cs.Bettype = @Bettype


