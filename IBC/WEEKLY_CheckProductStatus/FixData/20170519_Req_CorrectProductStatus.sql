-- Number Game: (161)
--1	Super IsDisabled= 1, Master IsDisabled = 0	161	Number Game	0	0	25		dummy super: update enable,
UPDATE ci
	SET DisableNumber = 0
FROM custInfo ci WITH (ROWLOCK) 
WHERE ci.custid IN (726483,726562,478396,984326,674248)

/*
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

--3	Agent IsDisabled= 1, Member IsDisabled = 0	212	Macau Games	0	1	1	Betdaq - Internal use  BET2	update member disabled
UPDATE CPS
	SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, T.bitmapOrder, 1)
	
FROM CustProductStatus CPS WITH (ROWLOCK)
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 212
				)AS T

WHERE CPS.CustID = 24021039
/*
-- 4	Super IsHidden= 1, Master IsHidden= 0	180	Virtual Sports	0	0	1		update master ishidden=1 and downline master
CustInfo.DisableVirtualSports	CustInfo.HideVirtualSports
*/
UPDATE ci
	SET HideVirtualSports = 1
FROM custInfo ci WITH (ROWLOCK) 
WHERE ci.mrecommend = 404713


/*
5	Master IsHidden= 1, Agent IsHidden= 0	212	Macau Games	0	1	1	checking	update agent hidden=1
*/
UPDATE CPS
	SET bitmapIsHidden = dbo.f_GenerateProductStatus(bitmapIsHidden, T.bitmapOrder, 1)
	
FROM CustProductStatus CPS WITH (ROWLOCK)
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 212
				)AS T

WHERE CPS.CustID = 752044

/*
	6	Agent IsHidden= 1, Member IsHidden= 0	206	Cockfighting	0	1	1		update member ishidden=1
*/
UPDATE CPS
	SET bitmapIsHidden = dbo.f_GenerateProductStatus(bitmapIsHidden, T.bitmapOrder, 1)
	
FROM CustProductStatus CPS WITH (ROWLOCK)
	CROSS APPLY (SELECT bitmapOrder
				FROM ProductStatusProfile WITH (NOLOCK)
				WHERE Sporttype = 206
				)AS T

WHERE CPS.CustID = 19542865
/*
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


