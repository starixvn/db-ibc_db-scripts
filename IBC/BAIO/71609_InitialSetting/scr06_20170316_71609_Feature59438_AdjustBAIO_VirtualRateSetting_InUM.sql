/*
	Created: Helen
	Task: Adjust Outright Setting 
	DB: DBCUST/CustDB
	Date: 20160715
	
	/*
		Virtual Rate Setting: When inserting initial data, shall copy from Basketball (Sporttype = 2)- HDP bettype (1) (for Moneyline) and Basketball - 1st HDP (for 1st Moneyline)
			Requirements:Sporttype = 2
			For bettype 20: copy from bettype 1 (HDP)
			For bettype 21: copy from bettype 7 (First HDP)
	*/
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
	CROSS APPLY( SELECT T.profileID	AS '@p',
						T.value AS '@v'
				 FROM	(
							SELECT	ipvs.profileID		,
									dbo.f_GetVirtualSetting(T.bitmapVirtual, T.profileID) AS value 
							FROM #ProfileVirtualSetting	AS ipvs WITH (NOLOCK)
								-- GET profileID of bettype Ref
								CROSS APPLY (SELECT pvs_ref.profileID,cvs_ref.bitmapVirtual 
											 FROM CustVirtualSetting cvs_ref WITH (NOLOCK)
												INNER JOIN ProfileVirtualSetting pvs_ref WITH (NOLOCK) ON cvs_ref.seqNo = pvs_ref.seqNo AND pvs_ref.islive = ipvs.islive
											 WHERE cvs_ref.custid = CVS.custid 
													 AND pvs_ref.sporttype = 2 
													 AND pvs_ref.bettype = (CASE WHEN ipvs.bettype = 20 THEN 1 ELSE 7 END)
											) AS T
							WHERE SUBSTRING(T.bitmapVirtual, 1+((T.profileID-1)%64), 1) <> SUBSTRING(cvs.bitmapVirtual, 1+((ipvs.profileID-1)%64), 1)
						) AS T
				 FOR XML PATH ('r'),root
				 ) AS Result (virtualXML)
		
WHERE CVS.seqNo = 3 AND Result.virtualXML IS NOT NULL

