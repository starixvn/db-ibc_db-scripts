 ﻿/*
	Created: Elodie
	Date: 2015-08-20
	Task: adjust Max Keno settings after copying for credit customers
	DB: DBCUST/CustDB
	Runtime: UM
*/ 
--STEP 1: copy settings for newly created credit customers
CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
GO

DECLARE @maxcustid INT 
SELECT @maxcustid = xx --lastest custid

	INSERT INTO [dbo].[CustGameType]
			   ([CustID]
			   ,[GameTypeID]
			   ,[StakeLevelList]
			   ,[MaxPerGameType]
			   ,[MinBet]
			   ,[MaxBet]
			   ,[IsDisabled])
    SELECT cg.[CustID]
		   ,15 as [GameTypeID]
		   ,[StakeLevelList]
		   ,[MaxPerGameType]
		   ,[MinBet]
		   ,[MaxBet]
		   ,[IsDisabled]
    FROM [CustGameType] cg WITH(NOLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cg.custid = ci.custid
    WHERE ci.srecommend IN (SELECT custid FROM #supers)
		 AND ci.custid > @maxcustid
		 AND gameTypeID = 1		 		
GO		 

--STEP 2: Adjust settings for credit customers

--adjust [CustGameType]
UPDATE cg1
SET cg1.[StakeLevelList] = cg2.[StakeLevelList]
   ,cg1.[MaxPerGameType] = cg2.[MaxPerGameType]
   ,cg1.[MinBet] = cg2.[MinBet]
   ,cg1.[MaxBet] = cg2.[MaxBet]
   ,cg1.[IsDisabled] = cg2.[IsDisabled]
FROM [CustGameType] cg1 WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cg1.custid = ci.custid
	INNER JOIN [CustGameType] cg2 WITH(NOLOCK) ON cg2.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
	AND cg1.gameTypeID = 15
	AND cg2.GameTYpeID = 1
	AND ( cg1.[StakeLevelList] <> cg2.[StakeLevelList]
		   OR cg1.[MaxPerGameType] <> cg2.[MaxPerGameType]
		   OR cg1.[MinBet] <> cg2.[MinBet]
		   OR cg1.[MaxBet] <> cg2.[MaxBet]
		   OR cg1.[IsDisabled] <> cg2.[IsDisabled]
		 )
GO
--------------------------------------------------------------------