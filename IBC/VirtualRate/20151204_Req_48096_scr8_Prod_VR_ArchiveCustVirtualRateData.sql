/*
	Created: 20151201@Billy
	Task: Archive old disabled users' virtual rate data (Non UM-Time)
	DB: DBCUST/CustDB & DBARCCUST/bodb_Customer
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

DECLARE @srecommend INT

SELECT i.custid, CAST(0 AS BIT) isFinished
INTO #supers
FROM custInfo i WITH(NOLOCK)
WHERE i.roleid = 4

WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #supers
	SET	isFinished = 1,
		@srecommend = custid
	WHERE isFinished = 0

	IF @@rowcount = 0
		BREAK

	;WITH PivotData AS (
		SELECT cvr.custid, seqNo, profileID,		
			CAST(COALESCE(CAST(cvr.virtualMultiplier*100 AS INT), 100) AS BINARY(1)) as bitmap
		FROM 		ProfileVirtualSetting AS pvs WITH(NOLOCK)
		LEFT JOIN 	CustVirtualRate AS cvr WITH(NOLOCK)	ON 	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
		INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = cvr.custid 
			AND pvs.bettype = cvr.bettype
			AND pvs.islive = cvr.isLive
		WHERE ci.srecommend = @srecommend
		AND [Enabled] = 0
	)
	INSERT INTO DBARCCUST.bodb_Customer.dbo.CustVirtualSetting_Old (custid, seqNo, bitmapVirtual)
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
		) AS P;
END
GO


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBARCCUST/bodb_Customer	 --
-------------------------------------------------------------------

SELECT pvs.profileID, pvs.sporttype, pvs.bettype, pvs.islive, pvs.seqNo, pvs.isActive
INTO #ProfileVirtualSetting
FROM DBCUST.CustDB.dbo.ProfileVirtualSetting pvs WITH(NOLOCK)

SELECT DISTINCT cvro.custid, CAST(0 AS BIT) isFinished
INTO #archiving
FROM CustVirtualRate_old cvro WITH(NOLOCK)
WHERE cvro.custid NOT IN (SELECT DISTINCT cvso.custid FROM CustVirtualSetting_Old cvso WITH(NOLOCK))

CREATE TABLE #tmp(CustID INT)

-- Loop until all customers are archived
DELETE #tmp

UPDATE	TOP(10000) #archiving
SET		isFinished = 1
OUTPUT	DELETED.custid
INTO	#tmp
WHERE	isFinished = 0

;WITH PivotData AS (
	SELECT cvr.custid, seqNo, profileID,		
		CAST(COALESCE(CAST(cvr.virtualMultiplier*100 AS INT), 100) AS BINARY(1)) as bitmap
	FROM 		#ProfileVirtualSetting AS pvs WITH(NOLOCK)
	LEFT JOIN 	CustVirtualRate_old AS cvr WITH(NOLOCK)	ON 	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
	INNER JOIN #tmp t WITH(NOLOCK) 
		ON	t.custid = cvr.custid 
		AND	pvs.bettype = cvr.bettype
		AND	pvs.islive = cvr.isLive
)
INSERT INTO CustVirtualSetting_Old (custid, seqNo, bitmapVirtual)
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
	) AS P;

--DROP TABLE #supers
--DROP TABLE #tmp
--DROP TABLE #ProfileVirtualSetting
--DROP TABLE #archiving
