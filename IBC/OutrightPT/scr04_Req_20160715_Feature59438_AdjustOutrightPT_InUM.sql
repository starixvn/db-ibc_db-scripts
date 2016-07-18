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
	INNER JOIN 
	(SELECT cs.custid,  apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
			,autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
	FROM custsetting cs (NOLOCK) 
		INNER JOIN #SportTypeBetType bt  ON bt.SportType = cs.sporttype AND bt.Bettype = cs.bettype
	WHERE cs.sporttype = 1 AND cs.bettype = 10
	) AS temp_pt ON cs.custid = temp_pt.custid 
			AND (cs.apositiontaking <> temp_pt.apositiontaking 
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
				  

--2. custoverride

UPDATE cs
	SET 
		-- Update PT
		minpositiontaking = temp_pt.minpositiontaking
		, maxpositiontaking = temp_pt.maxpositiontaking
		, minlivepositiontaking = temp_pt.minlivepositiontaking
		, maxlivepositiontaking = temp_pt.maxlivepositiontaking
		
FROM custoverride cs
	INNER JOIN 
	(SELECT cs.custid,  minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking
	FROM custoverride cs (NOLOCK) 
		INNER JOIN #SportTypeBetType bt  ON bt.SportType = cs.sporttype AND bt.Bettype = cs.bettype
	WHERE cs.sporttype = 1 AND cs.bettype = 10
	) AS temp_pt ON cs.custid = temp_pt.custid 
			AND (cs.minpositiontaking <> temp_pt.minpositiontaking
				OR cs.maxpositiontaking <> temp_pt.minpositiontaking
				OR cs.minlivepositiontaking <> temp_pt.minpositiontaking
				OR cs.maxlivepositiontaking <> temp_pt.minpositiontaking)
					  
				  
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
	INNER JOIN 
	(SELECT cs.custid, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf
	FROM custsetting cs (NOLOCK) 
		INNER JOIN #SportTypeBetType bt  ON bt.SportType = cs.sporttype AND bt.Bettype = cs.bettype
	WHERE cs.sporttype = 1 AND cs.Bettype = 9999
	) AS temp_pt ON cs.custid = temp_pt.custid 
	
	AND (cs.playerdiscount <> temp_pt.playerdiscount
		OR cs.discount <> temp_pt.discount
		OR cs.adiscount <> temp_pt.adiscount
		OR cs. sdiscount <> temp_pt.sdiscount
		OR cs.groupa <> temp_pt.groupa
		OR cs.groupb <> temp_pt.groupb
		OR cs.groupc <> temp_pt.groupc
		OR cs.groupd <> temp_pt.groupd
		OR cs.groupe <> temp_pt.groupe
		OR cs.groupf <> temp_pt.groupf
	
	)			 
		 
-------- Update BetSetting -----------
-- NO NEED SINCE IT'S GETTING ITSELFT

