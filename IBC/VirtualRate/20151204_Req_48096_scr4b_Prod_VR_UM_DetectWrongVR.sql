/*
	Created: 20151203@Billy
	Task: 
	DB: DBCUST/CustDB
*/

SELECT	cvr.custid, pvs.sporttype, pvs.bettype, pvs.islive, CAST(cvr.virtualMultiplier*100 AS INT) virtualMultiplier
INTO	#OldData
FROM		##AdjustVirtualRate avr
INNER JOIN	CustVirtualRate cvr WITH(NOLOCK)
		ON	avr.OldCustID = cvr.custid
INNER JOIN	ProfileVirtualSetting pvs WITH(NOLOCK)
		ON	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
		AND pvs.bettype = cvr.bettype
		AND pvs.islive = cvr.isLive

SELECT	cvs.custid, pvs.sporttype, pvs.bettype, pvs.islive, CAST(SUBSTRING(cvs.bitmapVirtual, (pvs.profileID - 1) % 64 + 1, 1) AS INT) virtualMultiplier
INTO #NewData
FROM		##AdjustVirtualRate avr
INNER JOIN	CustVirtualSetting cvs WITH(NOLOCK)
		ON	avr.NewCustID = cvs.custid
INNER JOIN	ProfileVirtualSetting pvs WITH(NOLOCK)
		ON	cvs.seqNo = pvs.seqNo

SELECT od.custid, od.sporttype, od.bettype, od.islive, od.virtualMultiplier oldVR, nd.virtualMultiplier newVR
FROM		#OldData od
INNER JOIN	#NewData nd
		ON	od.custid = nd.custid
		AND	od.sporttype = nd.sporttype
		AND	od.bettype = nd.bettype
		AND	od.islive = nd.islive
WHERE	od.virtualMultiplier <> nd.virtualMultiplier


--DROP TABLE #OldData
--DROP TABLE #NewData