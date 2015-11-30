/*
	Created: 20151127@Billy
	Task: Adjust data on Production environment (UM Time)
	DB: DBCUST/CustDB & DBACC/bodb02
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Execrep SP for importing Virtual Rate settings from old table [CustVirtualRate] to new table [CustVirtualSetting] --
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@time		DATETIME,
	@maxCustID	INT
AS
BEGIN
	SET NOCOUNT ON

	IF	(	SELECT	COUNT(1)
			FROM	sys.tables WITH(NOLOCK)
			WHERE	name IN ('CustVirtualRate', 'CustVirtualSetting', 'ProfileVirtualSetting', 'custInfo')
		) <> 4
		RETURN

	SELECT DISTINCT cvrh.custid
	INTO #ModifiedCustomers
	FROM DB06.bodb_CustHistory.dbo.CustVirtualRate_History cvrh WITH(NOLOCK)
	WHERE UpdateTime >= @time
	AND cvrh.custid <= @maxCustID
		
	;WITH PivotData AS (
		SELECT cvr.custid, seqNo, profileID,		
			CAST(COALESCE(CAST(cvr.virtualMultiplier*100 AS INT), 100) AS BINARY(1)) as bitmap
		FROM 		ProfileVirtualSetting AS pvs WITH(NOLOCK)
		LEFT JOIN 	CustVirtualRate AS cvr WITH(NOLOCK)	
				ON 	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
		INNER JOIN	#ModifiedCustomers mc WITH(NOLOCK) 
				ON	mc.custid = cvr.custid 
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
	UPDATE cvs
	SET bitmapVirtual = bd.bitmap
	FROM CustVirtualSetting cvs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN BitmapData bd
	ON cvs.custid = bd.custid
	AND cvs.seqNo = bd.seqNo
END
GO

-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------
DECLARE @maxCustID INT

SET @maxCustID = xxx

EXECUTE Acc_CustSetting3rd_19 @time = '2015-12-03 00:00:00.000', @maxCustID = @maxCustID
GO