/*
	Created: Helen
	Task: Copy BAIO Setting for newly created customer
	DB: DBCUST/CustDB
	Date: 20170316
*/ 

DECLARE @Sporttype SMALLINT = 2, @Bettype SMALLINT = 9999, @SporttypeRef SMALLINT = 2, @BettypeRef SMALLINT = 1

DECLARE @MaxCustID INT
	
SELECT @MaxCustID = xxx
	
CREATE TABLE #supers (custid INT,IsLicensee BIT)
CREATE TABLE #DownlineListTemp (CustID INT PRIMARY KEY CLUSTERED, RoleID INT)
--CREATE TABLE #ProfileVirtualSetting (sporttype SMALLINT,bettype SMALLINT,isLive BIT, ProfileID INT )
--CREATE TABLE #ProfileVirtualSetting_all (sporttype SMALLINT,bettype SMALLINT,isLive BIT, seqNo INT,ProfileID INT)

--CREATE NONCLUSTERED INDEX inx_temp ON #ProfileVirtualSetting_all( sporttype, bettype, seqNo,islive )
--INCLUDE (ProfileID)

--- GET super List ---
INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH (NOLOCK) 
WHERE ci.roleid = 4 AND CI.custid NOT IN (SELECT Custid FROM Dep_CustSuper CSD WITH(NOLOCK))
	 
--- GET All downline
INSERT INTO #DownlineListTemp (CustID,RoleID)
SELECT ci.custid,ci.roleid
FROM Custinfo ci WITH (NOLOCK)
	INNER JOIN #supers s ON ci.srecommend = s.custid
WHERE ci.Enabled = 1 AND ci.custid > @MaxCustID
	

--INSERT INTO #ProfileVirtualSetting (sporttype,bettype,isLive,ProfileID)
--SELECT sporttype,bettype,isLive,ProfileID
--FROM ProfileVirtualSetting WITH (NOLOCK) 
--WHERE sporttype = 2 AND bettype IN (20,21) 

--INSERT INTO #ProfileVirtualSetting_all (sporttype,bettype,isLive,seqNo,ProfileID)
--SELECT sporttype,bettype,isLive,seqNo,ProfileID
--FROM ProfileVirtualSetting WITH (NOLOCK)

------------------------------------ PT/Bet/Com Setting -------------------------------------------------------------
INSERT INTO custsetting (custid, sporttype,Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking	)
SELECT
		cs.custid, @Sporttype,@Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
		, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet
		, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
FROM custsetting cs (NOLOCK) 
		INNER JOIN #DownlineListTemp t ON cs.custid = t.CustID 
WHERE cs.sporttype = @SporttypeRef AND cs.bettype = @BettypeRef
	
INSERT INTO custoverride (custid, bettype, sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking)
SELECT cs.custid, @Bettype, @Sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking
FROM custoverride cs WITH (NOLOCK)
	INNER JOIN #DownlineListTemp t (NOLOCK) ON t.CustID = cs.custid AND RoleID IN (2,3,4) 
WHERE cs.sporttype = @SporttypeRef AND cs.bettype = @BettypeRef

------------------------------------ Vitual Rate Setting -------------------------------------------------------------
--UPDATE cvs
--	SET bitmapVirtual = (SELECT TOP 1 bitmap FROM dbo.f_GenerateVirtualSetting_multiple(cvs.bitmapVirtual, CONVERT(VARCHAR(MAX),Result.virtualXML))) 
--FROM CustVirtualSetting	AS cvs WITH (UPDLOCK, ROWLOCK)
--	INNER JOIN	#DownlineListTemp AS ci WITH (NOLOCK)	ON	ci.custid = cvs.custid 
--		CROSS APPLY( SELECT(
--							SELECT	ipvs.profileID			AS '@p',
--									dbo.f_GetVirtualSetting(T.bitmapVirtual, T.profileID) AS '@v'
--							FROM #ProfileVirtualSetting	AS ipvs WITH (NOLOCK)
--								-- GET profileID of bettype Ref
--								CROSS APPLY (SELECT pvs_ref.profileID,cvs_ref.bitmapVirtual 
--											 FROM CustVirtualSetting cvs_ref WITH (NOLOCK)
--												INNER JOIN #ProfileVirtualSetting_all pvs_ref WITH(NOLOCK) ON cvs_ref.seqNo = pvs_ref.seqNo AND pvs_ref.islive = ipvs.islive
--											 WHERE cvs_ref.custid = CVS.custid 
--													 AND pvs_ref.sporttype = 2 
--													 AND pvs_ref.bettype = (CASE WHEN ipvs.bettype = 20 THEN 1 ELSE 7 END)
--											) AS T
							
--							WHERE ipvs.sporttype = 2 AND ipvs.bettype IN (20,21)
							
--							FOR XML PATH ('r'),	TYPE
--						)
--					FOR XML PATH ('root'),	TYPE
--				) AS Result (virtualXML)
		
--WHERE CVS.seqNo = 3

DROP TABLE #DownlineListTemp

DROP TABLE #supers
