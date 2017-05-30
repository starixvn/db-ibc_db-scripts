/*
		Created: 20170519@Helen
		Task: Correct ProductStatus - Sheet "WeeklyCheckProductStatus_20170518" - Summary Report - #1,#4,#5,#6,#7,#9
		DB: DBCUST/CUSTDB
		
		Execution Date:N/A
		
*/
USE CustDB
GO
--#1: Number Game: (161) - dummy super: update enable
--1	Super IsDisabled= 1, Master IsDisabled = 0	161	Number Game	0	0	25		dummy super: update enable,
/*we don't touch on all accounts under this NG-sporttype-161
UPDATE ci
	SET DisableNumber = 0
FROM custInfo ci WITH (ROWLOCK) 
WHERE ci.custid IN (4,16,35,478396,674248,726483,726562,984326)
*/
/* #4: update member disabled; #8: update member ishidden=1

  3	Agent IsDisabled= 1, Member IsDisabled = 0	206	Cockfighting	0	1	1		update member disabled
  6	Agent IsHidden= 1, Member IsHidden= 0	206	Cockfighting	0	1	1		update member ishidden=1
*/
UPDATE CPS
	SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, T.bitmapOrder, 1)
	,	bitmapIsHidden = dbo.f_GenerateProductStatus(bitmapIsHidden, T.bitmapOrder, 1)
FROM CustProductStatus CPS WITH (ROWLOCK)
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 206
				)AS T

WHERE CPS.CustID = 19542865

/*#5: update member disabled */
--3	Agent IsDisabled= 1, Member IsDisabled = 0	212	Macau Games	0	1	1	Betdaq - Internal use  BET2	update member disabled
UPDATE CPS
	SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, T.bitmapOrder, 1)
		,bitmapHasSynced = dbo.f_GenerateProductStatus(bitmapHasSynced, T.bitmapOrder, 0)
FROM CustProductStatus CPS WITH (ROWLOCK)
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 212
				)AS T

WHERE CPS.CustID = 24021039
/* #6: update master ishidden=1 and downline master

-- 4	Super IsHidden= 1, Master IsHidden= 0	180	Virtual Sports	0	0	1		update master ishidden=1 and Disable = 0
CustInfo.DisableVirtualSports	CustInfo.HideVirtualSports
*/
-- 5 affected accounts
UPDATE ci
	SET HideVirtualSports = 1, DisableVirtualSports = 0
FROM custInfo ci WITH (ROWLOCK) 
WHERE ci.custid = 404713


/* #7 - update agent hidden=1 
5	Master IsHidden= 1, Agent IsHidden= 0	212	Macau Games	0	1	1	checking	update agent hidden=1
*/
UPDATE CPS
	SET bitmapIsHidden = dbo.f_GenerateProductStatus(bitmapIsHidden, T.bitmapOrder, 1)
		,bitmapHasSynced = dbo.f_GenerateProductStatus(bitmapHasSynced, T.bitmapOrder, 0)
FROM CustProductStatus CPS WITH (ROWLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CPS.CustID = CI.custid AND CI.Enabled = 1
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 212
				)AS T

WHERE CI.recommend = 752044



/* #9: update member follow agent, ignore  S305R0322

6	Agent IsHidden= 1, Member IsHidden= 0	212	Macau Games	0	1	9	member is direct acc (bug # #71925)	update member follow agent, ignore  S305R0322
*/
UPDATE CPS
	SET bitmapIsHidden = dbo.f_GenerateProductStatus(bitmapIsHidden, T.bitmapOrder, 1)
FROM CustProductStatus CPS WITH (ROWLOCK)
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 212
				)AS T
WHERE CPS.CustID in (24629408,24629447,24927647,25163750,24021039,23146856,24371067,24593501,24657793)


UPDATE CPS
	SET bitmapHasSynced = dbo.f_GenerateProductStatus(bitmapHasSynced, T.bitmapOrder, 0)
FROM CustProductStatus CPS WITH (ROWLOCK)
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 212
				)AS T
WHERE CPS.CustID in (24629408,24629447,24927647,25163750,24021039,24371067,24593501,24657793) -- remove updating for 23146856 since his upline synced

-- -- 1270 update agent wsrmb and downline Sync=0
UPDATE CPS
	SET bitmapHasSynced = dbo.f_GenerateProductStatus(bitmapHasSynced, T.bitmapOrder, 0)
FROM CustProductStatus CPS WITH (ROWLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CPS.CustID = CI.custid
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 212
				)AS T
WHERE CI.recommend = 1270 AND roleid IN (1,2) AND CI.Enabled = 1
-- #16:IsSync = 0, IsDisabled = 0	212	Macau Games	0	1	6		update isdisable = 1
UPDATE CPS
	SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, T.bitmapOrder, 1)
FROM CustProductStatus CPS WITH (ROWLOCK)
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 212
				)AS T
WHERE CPS.CustID in (4183,4177,1265,19545984,31987,19542865)

