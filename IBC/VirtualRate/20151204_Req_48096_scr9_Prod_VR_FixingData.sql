DELETE FROM CustVirtualSetting
WHERE custid IN (SELECT OldCustID FROM ##AdjustVirtualRate)

;WITH PivotData AS (
	SELECT cvr.custid, seqNo, profileID,		
		CAST(COALESCE(CAST(cvr.virtualMultiplier*100 AS INT), 100) AS BINARY(1)) as bitmap
	FROM 		ProfileVirtualSetting AS pvs WITH(NOLOCK)
	LEFT JOIN 	CustVirtualRate AS cvr WITH(NOLOCK)	
			ON 	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
	INNER JOIN	custInfo i WITH(NOLOCK) 
			ON	i.custID = cvr.custid 
			AND pvs.bettype = cvr.bettype
			AND pvs.islive = cvr.isLive
	WHERE	i.custid IN (SELECT OldCustID FROM ##AdjustVirtualRate)
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