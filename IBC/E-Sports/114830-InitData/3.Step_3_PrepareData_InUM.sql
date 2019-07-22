/*
	Task: Prepare raw data in UM - Redmine: 114830
		Step 1: Get terminated srecommend
		Step 2: Insert raw data with custid in [MaxCustID1 + 1 , MaxCustID2]
		Step 3: Create indexes
	Creator: Dominic@20190718
	Run at: CustDB@DBCUST 
*/
USE CustDB
GO
	--Step 1: Get terminated srecommend
	CREATE TABLE #TerminatedLicSuper (CustID INT)

	INSERT INTO #TerminatedLicSuper(CustID)
	SELECT CustID 
	FROM dep_custsuper (NOLOCK)
	WHERE Site IN  
	(
		'VCAsia'
		,'SHABAING'
		,'CQ11'
		,'i668bet'
		,'RYB95'
		,'Kasking88'
		,'Allbetclub'
		,'67BET'
		,'Bwinning'
		,'TooBet'
		,'GooBet'
		,'Winner99'
		,'Doctorgame'
		,'Mgm88'
		,'SLC88'
		,'Bet2day'
		,'King10'
		,'DUOLE'
		,'MarvelDH'
		,'Saloncs'
		,'THBET'
		,'Hbobet'
		,'Indowin'
		,'Leon'
		,'Empire555'
		,'Inbet'
		,'21Cash'
		,'BuyWin'
		,'Emmyo'
		,'DAYWIN'
		,'ABB688'
		,'28BET'
		,'99UU'
		,'TCL'
		,'LongBao'
		,'AK318'
		,'Wuming'
		,'Asianbet'
		,'WM8888'
		,'Platinum'
		,'Star99'
		,'VGS'
		,'K8'
		,'10BET'
		,'666VIP'
		,'Holey'
		,'Aragon88'
		,'Lexibet'
		,'GDC'
		,'Baobet'
		,'May88'
		,'LZYQ'
		,'YHY1980'
		,'108bet'
		,'Haoying'
		,'Jinmangguo'
		,'Sbcbet'
	)

	CREATE UNIQUE CLUSTERED INDEX CIX_CustID ON #TerminatedLicSuper(CustID)


	--Step 2: Insert raw data with custid in [MaxCustID1 + 1 , MaxCustID2]
	DECLARE @MaxCustID INT = MaxCustID2
	DECLARE @CustID INT = MaxCustID1 + 1
		
	DECLARE @sCustID VARCHAR(100)			
	WHILE (@CustID <= @MaxCustID)			
	BEGIN			
		INSERT INTO EsportVR_Temp	WITH(TABLOCK) (VRValue_121,VRValue_122,VRValue_123,VRValue_124,VRValue_125
							,VRValue_126,VRValue_127,VRValue_128
							,srecommend
							,mrecommend
							,recommend
							,RoleID
							,CustID
					)	
		SELECT CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 121) ELSE 1 END VRValue_121
				, CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 122) ELSE 1  END VRValue_122
				, CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 123) ELSE 1  END VRValue_123
				, CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 124) ELSE 1  END VRValue_124
				, CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 125) ELSE 1  END VRValue_125
				, CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 126) ELSE 1  END VRValue_126
				, CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 127) ELSE 1  END VRValue_127
				, CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 128) ELSE 1  END VRValue_128
				,c.srecommend
				,c.mrecommend
				,c.recommend
				,c.roleid
				,cvs.CustID
		FROM [dbo].[CustVirtualSetting]  cvs(NOLOCK)	
		INNER JOIN custInfo c(NOLOCK) ON c.custid = cvs.custid
		LEFT JOIN custInfo r(NOLOCK) ON r.custid = c.recommend
		LEFT JOIN [dbo].[CustVirtualSetting]  rvs(NOLOCK) ON rvs.custid = r.custid AND rvs.seqNo=2
		WHERE cvs.seqNo=2 AND c.CustID BETWEEN @CustID AND @CustID + 100000	
			AND c.srecommend NOT IN (SELECT CustID FROM #TerminatedLicSuper)	
			AND ( c.roleid IN (2,3,4)
				OR (
					c.roleid = 1 AND c.Enabled = 1 AND
					(
						   CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 121) ELSE 1 END
							<> CASE WHEN r.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(rvs.bitmapVirtual, 121) ELSE 1 END
						OR CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 122) ELSE 1 END
							<> CASE WHEN r.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(rvs.bitmapVirtual, 122) ELSE 1 END
						OR CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 123) ELSE 1 END
							<> CASE WHEN r.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(rvs.bitmapVirtual, 123) ELSE 1 END
						OR CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 124) ELSE 1 END
							<> CASE WHEN r.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(rvs.bitmapVirtual, 124) ELSE 1 END
						OR CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 125) ELSE 1 END
							<> CASE WHEN r.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(rvs.bitmapVirtual, 125) ELSE 1 END
						OR CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 126) ELSE 1 END
							<> CASE WHEN r.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(rvs.bitmapVirtual, 126) ELSE 1 END
						OR CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 127) ELSE 1 END
							<> CASE WHEN r.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(rvs.bitmapVirtual, 127) ELSE 1 END
						OR CASE WHEN c.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(cvs.bitmapVirtual, 128) ELSE 1 END
							<> CASE WHEN r.VirtualMultiplier = 1 THEN dbo.f_GetVirtualSetting(rvs.bitmapVirtual, 128) ELSE 1 END
					)
				)
			)	
		OPTION(RECOMPILE)
			
		SELECT @CustID = @CustID + 100001			
		SELECT @sCustID = CAST(@CustID AS VARCHAR(100))		
			
		RAISERROR(@sCustID, 0, 1) WITH NOWAIT		
		WAITFOR DELAY '00:00:002'		
	END			


	--Step 3: Create a non clustered index
	CREATE CLUSTERED INDEX CIX_CustID ON EsportVR_Temp(CustID)
	GO

	CREATE NONCLUSTERED INDEX IX_RoleID ON EsportVR_Temp(RoleID)