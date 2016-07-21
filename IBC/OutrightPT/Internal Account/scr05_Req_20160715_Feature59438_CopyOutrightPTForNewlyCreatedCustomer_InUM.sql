/*
	Created: Helen
	Task: Copy Outright Setting for newly created customer
	DB: DBCUST/CustDB
	Date: 20160715
*/ 

DECLARE @MaxCustID INT
	
SELECT @MaxCustID = xxx
	
CREATE TABLE #DownlineListTemp
(
	CustID INT PRIMARY KEY CLUSTERED
)
	
CREATE TABLE #SportTypeBetType (SportType SMALLINT, Bettype SMALLINT)
INSERT INTO #SportTypeBetType
VALUES(2,10)
	,(3,10)
	,(5,10)
	,(8,10)
	,(10,10)
	,(11,10)
	,(99,10)

CREATE TABLE #supers (custid INT)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH (NOLOCK) 
 INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
 INNER JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
 AND ci.username NOT LIKE '3rdSuper%'
 AND cs.isinternal = 1
 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
 AND s.islicensee = 0
 


INSERT INTO #DownlineListTemp (CustID)
SELECT ci.custid
FROM Custinfo ci WITH (NOLOCK)
WHERE Enabled = 1 AND custid > @MaxCustID
	AND EXISTS (SELECT 1 FROM #supers WHERE custid = ci.srecommend )
	 
INSERT INTO custsetting (custid, sporttype,Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking	)
SELECT
		temp_pt.custid, temp_pt.sporttype,temp_pt.Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
		, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet
		, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking

FROM 
	(SELECT t.custid, bt.sporttype,bt.Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
			,autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
	FROM #DownlineListTemp t
		INNER JOIN custsetting cs (NOLOCK) ON t.CustID = cs.custid
		CROSS JOIN #SportTypeBetType bt 
	WHERE cs.sporttype = 1 AND cs.bettype = 10
	) AS temp_pt
	
	-- Commission
	CROSS APPLY (SELECT playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf
				 FROM custsetting cs WITH (NOLOCK) 
				 WHERE cs.Custid = temp_pt.custid AND cs.sporttype = 1 AND Bettype = 9999
				 ) AS temp_commsetting

	CROSS APPLY (SELECT TOP 1 minbet, maxbet
				 FROM custsetting cs WITH (NOLOCK) 
				 WHERE cs.Custid = temp_pt.custid AND cs.sporttype = temp_pt.SportType AND cs.Bettype <> 9
				 ) AS temp_betsetting

INSERT INTO custoverride (custid, bettype, sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking)
SELECT temp_pt.custid, bt.Bettype, bt.sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking
FROM #DownlineListTemp temp_pt
	INNER JOIN custoverride cs (NOLOCK) ON temp_pt.CustID = cs.custid
	CROSS JOIN #SportTypeBetType bt 
WHERE cs.sporttype = 1 AND cs.bettype = 10
					 
DROP TABLE #DownlineListTemp
DROP TABLE #SportTypeBetType