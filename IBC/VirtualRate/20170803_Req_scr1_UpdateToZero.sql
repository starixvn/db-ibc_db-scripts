/*
	Created: 20170803@Winnie
	Task: Modify Virtual Rate data following new requirements RedmineID: #81115
	DB: DBCUST/CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
	CREATE TABLE #supers (custid int)

	INSERT INTO #supers(custid)
	SELECT ci.custid
	FROM dbo.customer ci WITH (NOLOCK) 
	 INNER JOIN dbo.Dep_CustSuper cs WITH (NOLOCK) ON ci.custid = cs.custid
	WHERE ci.roleid = 4  

	DECLARE @bitmap200 BINARY(64)
	DECLARE @bitmap0_Seq1 BINARY(64)
	DECLARE @bitmap0_Seq3 BINARY(64)
	SELECT @bitmap200	=
					(
					SELECT TOP 1 bitmap
					FROM dbo.f_GenerateVirtualSetting_multiple(0x00, CONVERT(VARCHAR(MAX), virtualXML))
					) 
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
					SELECT CAST(3.00 AS SMALLMONEY) AS virtualMultiplier
					) vr
					WHERE ipvs.seqNo = pvs.seqNo
					FOR XML PATH ('r'), 
					TYPE
				)
				FOR XML PATH ('root'), 
				TYPE
				) AS virtualXML
			) p  
			WHERE pvs.seqNo = 1

	SELECT @bitmap0_Seq1	=
				(
				SELECT TOP 1 bitmap
				FROM dbo.f_GenerateVirtualSetting_multiple(0x00, CONVERT(VARCHAR(MAX), virtualXML))
				) 
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
		WHERE pvs.seqNo = 1

	SELECT @bitmap0_Seq3	=
			(
			SELECT TOP 1 bitmap
			FROM dbo.f_GenerateVirtualSetting_multiple(0x00, CONVERT(VARCHAR(MAX), virtualXML))
			) 
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
	WHERE pvs.seqNo = 3

	SELECT DISTINCT cs.custid
	INTO #temp
	FROM dbo.CustVirtualSetting cs WITH (NOLOCK) 
		INNER JOIN DBLOG.bodb_CustomerLog.dbo.UserLog_VirtualRateSettings ci WITH (NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #supers s ON ci.srecommend = s.custid
	WHERE bitmapVirtual = @bitmap200
	 AND seqNo = 1

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
	DROP TABLE #supers