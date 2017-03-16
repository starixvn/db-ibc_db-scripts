/*
	Created: Helen
	Task: Adjust Outright Setting 
	DB: DBCUST/CustDB
	Date: 20160715
*/ 
--------------------- Adjust Virtual Rate setting -------------------
CREATE TABLE #ProfileVirtualSetting (sporttype SMALLINT,bettype SMALLINT,isLive BIT, ProfileID INT )

INSERT INTO #ProfileVirtualSetting (sporttype,bettype,isLive,ProfileID)
SELECT sporttype,bettype,isLive,ProfileID
FROM ProfileVirtualSetting WITH (NOLOCK) 
WHERE sporttype = 2 AND bettype IN (20,21)

UPDATE cvs
		SET bitmapVirtual = (SELECT TOP 1 bitmap FROM dbo.f_GenerateVirtualSetting_multiple(cvs.bitmapVirtual, CONVERT(VARCHAR(MAX),Result.virtualXML))) 
FROM CustVirtualSetting	AS cvs WITH (UPDLOCK, ROWLOCK)
	CROSS APPLY( SELECT(
							SELECT	ipvs.profileID			AS '@p',
									dbo.f_GetVirtualSetting(T.bitmapVirtual, T.profileID) AS '@v'
							FROM #ProfileVirtualSetting	AS ipvs WITH (NOLOCK)
								-- GET profileID of bettype Ref
								CROSS APPLY (SELECT pvs_ref.profileID,cvs_ref.bitmapVirtual 
											 FROM CustVirtualSetting cvs_ref WITH (NOLOCK)
												INNER JOIN ProfileVirtualSetting pvs_ref WITH(NOLOCK) ON cvs_ref.seqNo = pvs_ref.seqNo AND pvs_ref.islive = ipvs.islive
											 WHERE cvs_ref.custid = CVS.custid 
													 AND pvs_ref.sporttype = 2 
													 AND pvs_ref.bettype = (CASE WHEN ipvs.bettype = 20 THEN 1 ELSE 7 END)
											) AS T
							
							WHERE ipvs.sporttype = 2 AND ipvs.bettype IN (20,21)
								AND dbo.f_GetVirtualSetting(T.bitmapVirtual, T.profileID) <> dbo.f_GetVirtualSetting(cvs.bitmapVirtual, ipvs.profileID)
								
							FOR XML PATH ('r'),	TYPE
						)
					FOR XML PATH ('root'),	TYPE
				) AS Result (virtualXML)
		
WHERE CVS.seqNo = 3 AND CVS.bitmapVirtual <> (SELECT TOP 1 bitmap FROM dbo.f_GenerateVirtualSetting_multiple(cvs.bitmapVirtual, CONVERT(VARCHAR(MAX),Result.virtualXML)))

