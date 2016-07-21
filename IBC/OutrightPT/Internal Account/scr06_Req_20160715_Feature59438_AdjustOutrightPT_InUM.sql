/*
	Created: Helen
	Task: Adjust Outright Setting 
	DB: DBCUST/CustDB
	Date: 20160715
*/ 

CREATE TABLE #SportTypeBetType (SportType SMALLINT, Bettype SMALLINT)
INSERT INTO #SportTypeBetType
VALUES(2,10)
	,(3,10)
	,(5,10)
	,(8,10)
	,(10,10)
	,(11,10)
	,(99,10)

CREATE TABLE #supers (custid int)

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

--------------------- Update PT -------------------
--1. CustSetting
UPDATE cs
	SET 
		-- Update PT
		apositiontaking = temp_pt.apositiontaking
		, mpositiontaking = temp_pt.mpositiontaking
		, spositiontaking = temp_pt.spositiontaking
		, alivepositiontaking = temp_pt.alivepositiontaking
		, mlivepositiontaking= temp_pt.mlivepositiontaking
		, slivepositiontaking = temp_pt.slivepositiontaking
		, autopositiontaking = temp_pt.autopositiontaking
		, autolivepositiontaking = temp_pt.autolivepositiontaking
		, isautopositiontaking = temp_pt.isautopositiontaking
		, isautolivepositiontaking = temp_pt.isautolivepositiontaking
		, autompositiontaking = temp_pt.autompositiontaking
		, autolivempositiontaking = temp_pt.autolivempositiontaking
		, isautompositiontaking = temp_pt.isautompositiontaking
		, isautolivempositiontaking = temp_pt.isautolivempositiontaking
		
FROM custsetting cs
	INNER JOIN customer c WITH (NOLOCK) ON cs.custid = c.custid
	INNER JOIN #SportTypeBetType bt  ON bt.SportType = cs.sporttype AND bt.Bettype = cs.bettype
	CROSS APPLY	(SELECT cs_temp.custid, apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
						,autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
				FROM custsetting cs_temp (NOLOCK) 
				WHERE cs_temp.sporttype = 1 AND cs_temp.bettype = 10 AND cs.custid = cs_temp.custid
				) AS temp_pt 

WHERE (cs.apositiontaking <> temp_pt.apositiontaking 
				 OR cs.mpositiontaking <> temp_pt.mpositiontaking 
				 OR cs.spositiontaking <> temp_pt.spositiontaking 
				 OR cs.alivepositiontaking <> temp_pt.alivepositiontaking 
				 OR cs.mlivepositiontaking <> temp_pt.mlivepositiontaking 
				 OR cs.slivepositiontaking <> temp_pt.slivepositiontaking 
				 OR cs.autopositiontaking <> temp_pt.autopositiontaking 
				 OR cs.autolivepositiontaking <> temp_pt.autolivepositiontaking 
				 OR cs.isautopositiontaking <> temp_pt.isautopositiontaking 
				 OR cs.isautolivepositiontaking <> temp_pt.isautolivepositiontaking 
				 OR cs.autompositiontaking <> temp_pt.autompositiontaking 
				 OR cs.autolivempositiontaking <> temp_pt.autolivempositiontaking 
				 
				 OR cs.isautompositiontaking <> temp_pt.isautompositiontaking 
				 OR cs.isautolivempositiontaking <> temp_pt.isautolivempositiontaking)
	AND c.srecommend IN (SELECT custid FROM #supers)
				  

--2. custoverride

UPDATE cs
	SET 
		-- Update PT
		minpositiontaking = temp_pt.minpositiontaking
		, maxpositiontaking = temp_pt.maxpositiontaking
		, minlivepositiontaking = temp_pt.minlivepositiontaking
		, maxlivepositiontaking = temp_pt.maxlivepositiontaking
		
FROM custoverride cs
	INNER JOIN customer c WITH (NOLOCK) ON cs.custid = c.custid
	INNER JOIN #SportTypeBetType bt  ON bt.SportType = cs.sporttype AND bt.Bettype = cs.bettype
	CROSS APPLY	(SELECT cs_temp.custid, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking
				 FROM custoverride cs_temp (NOLOCK) 
				 WHERE cs_temp.sporttype = 1 AND cs_temp.bettype = 10 AND cs.custid = cs_temp.custid
			) AS temp_pt 

WHERE (cs.minpositiontaking <> temp_pt.minpositiontaking
		OR cs.maxpositiontaking <> temp_pt.maxpositiontaking
		OR cs.minlivepositiontaking <> temp_pt.minlivepositiontaking
		OR cs.maxlivepositiontaking <> temp_pt.maxlivepositiontaking)
		AND c.srecommend IN (SELECT custid FROM #supers)
					  
				  
--------------- END OF updating PT ----------------

---------------- Update Comm ---------------------
UPDATE cs
	SET 
		playerdiscount = temp_pt.playerdiscount  
		, discount = temp_pt.discount
		, adiscount = temp_pt.adiscount
		, sdiscount =  temp_pt.sdiscount
		, groupa = temp_pt.groupa
		, groupb = temp_pt.groupb
		, groupc = temp_pt.groupc
		, groupd = temp_pt.groupd
		, groupe = temp_pt.groupe
		, groupf = temp_pt.groupf
		
FROM custsetting cs
	INNER JOIN customer c WITH (NOLOCK) ON cs.custid = c.custid
	INNER JOIN #SportTypeBetType bt  ON bt.SportType = cs.sporttype AND bt.Bettype = cs.bettype
	CROSS APPLY	(SELECT cs_temp.custid, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf
				FROM custsetting cs_temp (NOLOCK) 
				WHERE cs_temp.sporttype = 1 AND cs_temp.Bettype = 9999 AND cs.custid = cs_temp.custid
			) AS temp_pt
	
WHERE	(cs.playerdiscount <> temp_pt.playerdiscount
		OR cs.discount <> temp_pt.discount
		OR cs.adiscount <> temp_pt.adiscount
		OR cs. sdiscount <> temp_pt.sdiscount
		OR cs.groupa <> temp_pt.groupa
		OR cs.groupb <> temp_pt.groupb
		OR cs.groupc <> temp_pt.groupc
		OR cs.groupd <> temp_pt.groupd
		OR cs.groupe <> temp_pt.groupe
		OR cs.groupf <> temp_pt.groupf)
		AND c.srecommend IN (SELECT custid FROM #supers)
	
			 
		 
-------- Update BetSetting -----------
UPDATE cs
	SET 
		minbet = Temp_bet.minbet
	  , maxbet = Temp_bet.maxbet
		
FROM custsetting cs
	INNER JOIN customer c WITH (NOLOCK) ON cs.custid = c.custid
	INNER JOIN #SportTypeBetType sp ON cs.sporttype = sp.SportType AND cs.bettype = sp.Bettype
	CROSS APPLY (SELECT top 1 cs.custid, minbet, maxbet
				FROM custsetting cs_temp (NOLOCK) 
				WHERE  cs_temp.Bettype  <> 10 AND cs.sporttype = cs_temp.sporttype AND cs.custid = cs_temp.custid
				) AS Temp_bet
WHERE  (cs.minbet <> Temp_bet.minbet
	   OR cs.maxbet <> Temp_bet.maxbet)		
	   AND c.srecommend IN (SELECT custid FROM #supers)			

	
	

