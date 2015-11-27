/*
	Created: 20151126@Billy
	Task: Validate copied data on Production environment (Non-UM Time)
	DB: DBCUST/CustDB & DBACC/bodb02
	Note: Deploy this script on Publisher (DBCUST/CustDB) and all its Subscribers (DBACC/bodb02) to validate replicated data too
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT	--
--------------------------------------
CREATE FUNCTION dbo.f_VirtualRateBitmapChecksum (
	@bitmap BINARY(64)
)
RETURNS INT
AS
BEGIN
	DECLARE @result INT

	;WITH Data AS (
		SELECT pvs.profileID, s.vm
		FROM ProfileVirtualSetting pvs WITH(NOLOCK)
		CROSS APPLY (
			SELECT CAST(SUBSTRING(@bitmap, pvs.profileID, 1) AS INT) vm
		) s
		WHERE pvs.profileID <= 64
	)
	SELECT @result = SUM(vm)
	FROM Data

	RETURN @result
END 
GO

-- BEGIN STEP 2: DEPLOY THIS SCRIPT	--
--------------------------------------

-- Create new table for saving checksum value of old VirtualRate --
CREATE TABLE #VirtualRateCheckSumOLD (
	custID INT,
	VRSum INT,
	CONSTRAINT PK_VROld PRIMARY KEY CLUSTERED (custID ASC)
)
GO

-- Create new table for saving checksum value of new VirtualRate --
CREATE TABLE #VirtualRateCheckSumNEW (
	custID INT,
	VRSum INT,
	CONSTRAINT PK_VRNew PRIMARY KEY CLUSTERED (custID ASC)
)
GO

-- Calculate and insert checksum values into #VirtualRateCheckSumOLD table --
INSERT INTO #VirtualRateCheckSumOLD (custID, VRSum)
SELECT cvr.custid, SUM(CAST(cvr.virtualMultiplier*100 AS INT)) VRSum
FROM ProfileVirtualSetting pvs WITH(NOLOCK)
INNER JOIN CustVirtualRate cvr WITH(NOLOCK)
ON ((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
AND pvs.bettype = cvr.bettype
AND pvs.islive = cvr.isLive
GROUP BY cvr.custid
GO

-- Calculate and insert checksum values into #VirtualRateCheckSumNEW table --
INSERT INTO #VirtualRateCheckSumNEW (custID, VRSum)
SELECT cvs.custid, SUM(dbo.f_VirtualRateBitmapChecksum(cvs.bitmapVirtual))
FROM CustVirtualSetting cvs WITH(NOLOCK)
GROUP BY cvs.custid
GO

-- Validate data --
SELECT	vrcso.custID OldCustID,
		vrcso.VRSum OldCheckSum,
		vrcsn.custID NewCustID,
		vrcsn.VRSum NewCheckSum,
		CASE WHEN vrcsn.custID IS NULL THEN 1	-- No new settings (maybe caused by creating new customers)
			 WHEN vrcso.custID IS NULL THEN 2	-- No old settings (maybe caused by data from testing - SHOULD NEVER HAPPENED)
			 ELSE 3								-- The settings' checksum are not match
			 END Grp
FROM #VirtualRateCheckSumOLD vrcso WITH(NOLOCK)
FULL OUTER JOIN #VirtualRateCheckSumNEW vrcsn WITH(NOLOCK)
ON vrcso.custID = vrcsn.custID
WHERE vrcso.VRSum IS NULL
OR vrcso.VRSum IS NULL
OR vrcso.VRSum <> vrcsn.VRSum
ORDER BY Grp, OldCustID, NewCustID
GO

--DROP TABLE #VirtualRateCheckSumNEW
--DROP TABLE #VirtualRateCheckSumOLD
