/*
	Created: 20170804@Winnie
	Task: Modify Virtual Rate data following new requirements RedmineID: #81115
	DB: DBCUST/CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --

	DECLARE @bitmap0_Seq1 BINARY(64)
	DECLARE @bitmap0_Seq3 BINARY(64)
	CREATE TABLE #Temp (CustID INT PRIMARY KEY)
	SELECT seqNo,
		  (
		   SELECT TOP 1 bitmap
		   FROM dbo.f_GenerateVirtualSetting_multiple(0x00, CONVERT(VARCHAR(MAX), virtualXML))
		  ) AS bitmapVirtual
	INTO #XML
	FROM (
		SELECT DISTINCT seqNo
		FROM ProfileVirtualSetting WITH(NOLOCK)
		) pvs
		CROSS APPLY (
			SELECT (
			SELECT (
				SELECT ipvs.profileID   AS '@p',
				vr.virtualMultiplier AS '@v'
				FROM ProfileVirtualSetting AS ipvs WITH(NOLOCK)
				CROSS APPLY (
				SELECT CAST(1.00 AS SMALLMONEY) AS virtualMultiplier
				) vr
				WHERE ipvs.seqNo = pvs.seqNo
				FOR XML PATH ('r'), 
				TYPE
			)
			FOR XML PATH ('root'), 
			TYPE
			) AS virtualXML
		) p  
	
	SELECT @bitmap0_Seq1	=bitmapVirtual
	FROM #XML		
	WHERE seqNo = 1

	SELECT @bitmap0_Seq3	=bitmapVirtual
	FROM #XML		
	WHERE seqNo = 3	

	INSERT INTO #Temp(CustID)
	SELECT DISTINCT cvs.custid
	FROM  dbo.[ProfileVirtualSetting] pvs WITH(NOLOCK)
		INNER JOIN  [dbo].[CustVirtualSetting] cvs WITH(NOLOCK) ON pvs.seqNo=cvs.seqNo
		INNER JOIN custInfo c WITH(NOLOCK) ON cvs.custid=c.custid
		INNER JOIN Dep_CustSuper sup WITH(NOLOCK) ON c.srecommend=sup.custid  
	WHERE (SELECT val FROM [dbo].[f_GetVirtualRateSetting](cvs.bitmapVirtual,pvs.profileID))=3

	UPDATE cvs
		SET cvs.bitmapVirtual=@bitmap0_Seq1
	FROM	[dbo].[CustVirtualSetting] cvs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #temp t ON cvs.custid=t.custid
	WHERE seqNo IN(1,2)

	UPDATE cvs
		SET cvs.bitmapVirtual=@bitmap0_Seq3
	FROM	[dbo].[CustVirtualSetting] cvs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #temp t ON cvs.custid=t.custid
	WHERE seqNo=3

	DROP TABLE #temp
	DROP TABLE #XML