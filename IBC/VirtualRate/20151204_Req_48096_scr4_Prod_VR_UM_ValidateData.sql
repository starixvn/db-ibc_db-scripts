/*
	Created: 20151127@Billy
	Task: Validate copied data on Production environment (UM Time)
	DB: DBCUST/CustDB & DBACC/bodb02
	Note: Deploy this script on Publisher (DBCUST/CustDB) and all its Subscribers (DBACC/bodb02) to validate replicated data too
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT	--
--------------------------------------

-- Create new table for saving checksum value of old VirtualRate --
CREATE TABLE #VirtualRateCheckSumOLD (
	custID	INT PRIMARY KEY CLUSTERED,
	VRSum	INT
)
GO

-- Create new table for saving checksum value of new VirtualRate --
CREATE TABLE #VirtualRateCheckSumNEW (
	custID	INT PRIMARY KEY CLUSTERED,
	VRSum	INT
)
GO

-- Calculate and insert checksum values into #VirtualRateCheckSumOLD table --
INSERT INTO #VirtualRateCheckSumOLD (custID, VRSum)
SELECT	cvr.custid, SUM(CAST(cvr.virtualMultiplier*100 AS INT)) VRSum
FROM		ProfileVirtualSetting pvs WITH(NOLOCK)
INNER JOIN	CustVirtualRate cvr WITH(NOLOCK)
		ON	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
		AND pvs.bettype = cvr.bettype
		AND pvs.islive = cvr.isLive
GROUP BY cvr.custid
GO

-- Calculate and insert checksum values into #VirtualRateCheckSumNEW table --
INSERT INTO #VirtualRateCheckSumNEW (custID, VRSum)
SELECT	cvs.custid, SUM(dbo.f_VirtualRateBitmapChecksum(cvs.bitmapVirtual))
FROM	CustVirtualSetting cvs WITH(NOLOCK)
GROUP BY cvs.custid
GO

-- Validate data --
INSERT INTO AdjustVirtualRate (OldCustID, OldCheckSum, NewCustID, NewCheckSum, Grp)
SELECT	vrcso.custID OldCustID,
		vrcso.VRSum OldCheckSum,
		vrcsn.custID NewCustID,
		vrcsn.VRSum NewCheckSum,
		CASE WHEN vrcsn.custID IS NULL THEN 1	-- No new settings (maybe caused by creating new customers)
		--	 WHEN vrcso.custID IS NULL THEN 2	-- No old settings (maybe caused by new default data for existing customers that not have data yet)
			 ELSE 3								-- The settings' checksum are not match
			 END Grp
FROM			#VirtualRateCheckSumOLD vrcso WITH(NOLOCK)
FULL OUTER JOIN #VirtualRateCheckSumNEW vrcsn WITH(NOLOCK)
			ON	vrcso.custID = vrcsn.custID
WHERE	vrcsn.VRSum IS NULL
--	OR	vrcso.VRSum IS NULL
	OR	vrcso.VRSum <> vrcsn.VRSum
GO

-- View validate result --
SELECT	OldCustID, OldCheckSum, NewCustID, NewCheckSum, Grp
FROM	AdjustVirtualRate avr WITH(NOLOCK)
ORDER BY Grp, OldCustID, NewCustID
GO

--DROP TABLE #VirtualRateCheckSumNEW
--DROP TABLE #VirtualRateCheckSumOLD