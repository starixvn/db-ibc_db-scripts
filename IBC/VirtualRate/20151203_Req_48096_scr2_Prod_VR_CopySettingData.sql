/*
	Created: 20151126@Billy
	Task: Initial data on Production environment (Non-UM Time)
	DB: DBCUST/CustDB & DBACC/bodb02
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Execrep SP for importing Virtual Rate settings from old table [CustVirtualRate] to new table [CustVirtualSetting] --
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend	INT,
	@target		VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @counter INT

	IF (@target = 'REPLICATED' AND @@SERVERNAME =  'DBCUST')	-- Run at all replicated servers
		RETURN
	IF (@target = 'DBCUST'	   AND @@SERVERNAME <> 'DBCUST')	-- Run at DBCUST only
		RETURN

	IF	(	SELECT	COUNT(1)
			FROM	sys.tables WITH(NOLOCK)
			WHERE	name IN ('CustVirtualRate', 'CustVirtualSetting', 'ProfileVirtualSetting', 'CustInfo')
		) <> 4
		RETURN

		
	;WITH PivotData AS (
		SELECT cvr.custid, seqNo, profileID,		
			CAST(COALESCE(CAST(cvr.virtualMultiplier*100 AS INT), 100) AS BINARY(1)) as bitmap
		FROM 		ProfileVirtualSetting AS pvs WITH(NOLOCK)
		LEFT JOIN 	CustVirtualRate AS cvr WITH(NOLOCK)	ON 	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
		INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid = cvr.custid 
			AND pvs.bettype = cvr.bettype
			AND pvs.islive = cvr.isLive
		WHERE ci.srecommend = @srecommend
		AND [Enabled] = 1
	)
	INSERT INTO CustVirtualSetting(custid,seqNo,bitmapVirtual)
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


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON REPLICATED SERVER --
-----------------------------------------------------------

-- Selected super lines for import data --
CREATE TABLE	#supers (
					custid INT,
					isfinished BIT DEFAULT(0)
				)

DECLARE @srecommend INT

INSERT INTO	#supers (custid)
SELECT	ci.custid
FROM	custInfo AS ci WITH(NOLOCK)
WHERE	roleid = 4

-- Import virtual setting from old structure to new structure for selected super lines --
WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #supers
	SET		isfinished = 1,
			@srecommend = custid
	WHERE	isfinished = 0

	IF @@ROWCOUNT = 0
		BREAK

	EXECUTE Acc_CustSetting3rd_19 @srecommend = @srecommend, @target = 'REPLICATED'

	WAITFOR DELAY '00:00:00.280'
END
GO


-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Selected super lines for import data --
CREATE TABLE	#supers (
					custid INT,
					isfinished BIT DEFAULT(0)
				)

DECLARE @srecommend INT

INSERT INTO #supers (custid)
SELECT	ci.custid
FROM	custInfo AS ci WITH(NOLOCK)
WHERE	roleid = 4

-- Import virtual setting from old structure to new structure for selected super lines --
WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #supers
	SET		isfinished = 1,
			@srecommend = custid
	WHERE	isfinished = 0

	IF @@ROWCOUNT = 0
		BREAK

	EXECUTE Acc_CustSetting3rd_19 @srecommend = @srecommend, @target = 'DBCUST'

	WAITFOR DELAY '00:00:00.280'
END
GO