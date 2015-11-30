/*
	Created: 20151127@Billy
	Task: Validate copied data then adjust mismatch settings on Production environment (UM Time)
	DB: DBCUST/CustDB
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

-- Create new physical table for saving need-to-adjust-settings customers --
CREATE TABLE ##AdjustVirtualRate (
	OldCustID	INT,
	OldCheckSum INT,
	NewCustID	INT,
	NewCheckSum INT,
	isFinished	BIT
)
GO

-- Variable to store MaxCustID
DECLARE @maxCustID INT

SET @maxCustID = xxx

-- Calculate and insert checksum values into #VirtualRateCheckSumOLD table --
INSERT INTO #VirtualRateCheckSumOLD (custID, VRSum)
SELECT	cvr.custid, SUM(CAST(cvr.virtualMultiplier*100 AS INT)) VRSum
FROM		ProfileVirtualSetting pvs WITH(NOLOCK)
INNER JOIN	CustVirtualRate cvr WITH(NOLOCK)
		ON	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
		AND pvs.bettype = cvr.bettype
		AND pvs.islive = cvr.isLive
WHERE	cvr.custid <= @maxCustID
GROUP BY cvr.custid


-- Calculate and insert checksum values into #VirtualRateCheckSumNEW table --
INSERT INTO #VirtualRateCheckSumNEW (custID, VRSum)
SELECT	cvs.custid, SUM(dbo.f_VirtualRateBitmapChecksum(cvs.bitmapVirtual))
FROM	CustVirtualSetting cvs WITH(NOLOCK)
WHERE	cvs.custid <= @maxCustID
GROUP BY cvs.custid
GO

-- Validate data --
INSERT INTO ##AdjustVirtualRate (OldCustID, OldCheckSum, NewCustID, NewCheckSum, isFinished)
SELECT	vrcso.custID OldCustID,
		vrcso.VRSum OldCheckSum,
		vrcsn.custID NewCustID,
		vrcsn.VRSum NewCheckSum,
		0 isFinished
FROM		#VirtualRateCheckSumOLD vrcso WITH(NOLOCK)
INNER JOIN	#VirtualRateCheckSumNEW vrcsn WITH(NOLOCK)
		ON	vrcso.custID = vrcsn.custID
WHERE	vrcso.VRSum <> vrcsn.VRSum
GO

-- View validate result --
SELECT	OldCustID, OldCheckSum, NewCustID, NewCheckSum
FROM	##AdjustVirtualRate avr WITH(NOLOCK)
WHERE	avr.isFinished = 0
GO


-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------
CREATE TABLE #tmp(CustID INT)

-- Loop untill all customers are adjusted
DELETE #tmp

UPDATE	TOP(10000) ##AdjustVirtualRate
SET		isFinished = 1
OUTPUT	DELETED.OldCustID
INTO	#tmp
WHERE	isFinished = 0

;WITH PivotData AS (
	SELECT cvr.custid, seqNo, profileID,		
		CAST(COALESCE(CAST(cvr.virtualMultiplier*100 AS INT), 100) AS BINARY(1)) as bitmap
	FROM 		ProfileVirtualSetting AS pvs WITH(NOLOCK)
	LEFT JOIN 	CustVirtualRate AS cvr WITH(NOLOCK)	
			ON 	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
	INNER JOIN	#tmp t WITH(NOLOCK) 
			ON	t.CustID = cvr.custid 
			AND pvs.bettype = cvr.bettype
			AND pvs.islive = cvr.isLive
),
BitmapData AS (
	SELECT custid, seqNo,
		CASE WHEN seqNo = 1 THEN [1] +[2] +[3] +[4] +[5] +[6] +[7] +[8] +[9] +[10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[18]+[19]+[20]+[21]+[22]+[23]+[24]+[25]+[26]+[27]+[28]+[29]+[30]+[31]+[32]+[33]+[34]+[35]+[36] +[37] +[38] +[39] +[40] +[41] +[42] +[43] +[44] +[45] +[46] +[47] +[48] +[49] +[50] +[51] +[52] +[53] +[54] +[55] +[56] +[57]+[58]+[59]+[60]+[61]+[62]+[63]+[64]
				WHEN seqno = 2 THEN [65]+[66]+[67]+[68]+[69]+[70]+[71]+[72]+[73]+[74]+[75]+[76]+[77]+[78]+[79]+[80]+[81]+[82]+[83]+[84]+[85]+[86]+[87]+[88]+[89]+[90]+[91]+[92]+[93]+[94]+[95]+[96]+[97]+[98]+[99]+[100]+[101]+[102]+[103]+[104]+[105]+[106]+[107]+[108]+[109]+[110]+[111]+[112]+[113]+[114]+[115]+[116]+[117]+[118]+[119]+[120]+0x00+0x00+0x00+0x00+0x00+0x00+0x00+0x00
		END AS bitmap
	FROM PivotData 
	PIVOT (	MAX(bitmap) 
			FOR profileID IN (	[1]  , [2]  , [3]  , [4]  , [5]  , [6]  , [7]  , [8]  , [9]  , [10] ,
								[11] , [12] , [13] , [14] , [15] , [16] , [17] , [18] , [19] , [20] ,
								[21] , [22] , [23] , [24] , [25] , [26] , [27] , [28] , [29] , [30] ,
								[31] , [32] , [33] , [34] , [35] , [36] , [37] , [38] , [39] , [40] ,
								[41] , [42] , [43] , [44] , [45] , [46] , [47] , [48] , [49] , [50] ,
								[51] , [52] , [53] , [54] , [55] , [56] , [57] , [58] , [59] , [60] ,
								[61] , [62] , [63] , [64] , [65] , [66] , [67] , [68] , [69] , [70] ,
								[71] , [72] , [73] , [74] , [75] , [76] , [77] , [78] , [79] , [80] ,
								[81] , [82] , [83] , [84] , [85] , [86] , [87] , [88] , [89] , [90] ,
								[91] , [92] , [93] , [94] , [95] , [96] , [97] , [98] , [99] , [100],
								[101], [102], [103], [104], [105], [106], [107], [108], [109], [110],
								[111], [112], [113], [114], [115], [116], [117], [118], [119], [120]
							)
		) AS P
)
UPDATE	cvs
SET		bitmapVirtual = bd.bitmap
FROM	CustVirtualSetting cvs WITH(ROWLOCK,UPDLOCK)
INNER JOIN	BitmapData bd
		ON	cvs.custid = bd.custid
		AND cvs.seqNo = bd.seqNo
GO

--DROP TABLE #VirtualRateCheckSumNEW
--DROP TABLE #VirtualRateCheckSumOLD
--DROP TABLE ##AdjustVirtualRate