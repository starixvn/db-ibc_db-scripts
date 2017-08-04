/*
	Created: 20170804@Winnie
	Task: Modify Virtual Rate data following new requirements RedmineID: #81115
	DB: DBCUST/CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --

	CREATE TABLE #supers (custid INT PRIMARY KEY)
	CREATE TABLE #TempLog (custid INT PRIMARY KEY)
	CREATE TABLE #Temp (custid INT,sporttype INT,bettype INT,isLive BIT,virtualRate SMALLMONEY)

	INSERT INTO #supers(custid)
	SELECT ci.custid
	FROM dbo.customer ci WITH (NOLOCK) 
		INNER JOIN dbo.Dep_CustSuper cs WITH (NOLOCK) ON ci.custid = cs.custid
	WHERE ci.roleid = 4  

	INSERT INTO #TempLog(CustID)
	SELECT DISTINCT us.custid
	FROM DBLOG.bodb_CustomerLog.dbo.UserLog_VirtualRateSettings us WITH (NOLOCK)
	 INNER JOIN #supers s ON us.srecommend = s.custid
	WHERE NewVirtualRate = 3

	INSERT INTO #Temp(CustID,sporttype,bettype,isLive,virtualRate)
	SELECT DISTINCT cvs.custid,pvs.sporttype,pvs.bettype,pvs.islive,1.0
	FROM  dbo.[ProfileVirtualSetting] pvs WITH(NOLOCK)
		INNER JOIN  [dbo].[CustVirtualSetting] cvs WITH(NOLOCK) ON pvs.seqNo=cvs.seqNo
		INNER JOIN #TempLog c WITH(NOLOCK) ON cvs.custid=c.custid		
	WHERE (SELECT val FROM [dbo].[f_GetVirtualRateSetting](cvs.bitmapVirtual,pvs.profileID))=3
	
	UPDATE cvs
	SET		bitmapVirtual = (SELECT TOP 1 bitmap FROM dbo.f_GenerateVirtualSetting_multiple(bitmapVirtual, CONVERT(VARCHAR(MAX), virtualXML)))
	FROM		CustVirtualSetting AS cvs WITH(UPDLOCK, ROWLOCK)
	CROSS APPLY (
		SELECT (
			SELECT	(
						SELECT	ipvs.profileID			AS '@p',
								tmp.virtualRate			AS '@v'
						FROM		#Temp				AS tmp
						INNER JOIN	ProfileVirtualSetting	AS ipvs WITH(NOLOCK)
								ON	tmp.sporttype	= ipvs.sporttype
								AND tmp.bettype		= ipvs.bettype
								AND tmp.isLive		= ipvs.islive
						WHERE	ipvs.seqNo = cvs.seqNo
							AND tmp.custid = cvs.custid
						FOR XML PATH ('r'), 
						TYPE
					)
			FOR XML PATH ('root'), 
			TYPE
		) AS virtualXML
	) p
	WHERE cvs.custid IN (SELECT DISTINCT custid FROM #Temp)

	DROP TABLE #temp
	DROP TABLE #supers
	DROP TABLE #TempLog