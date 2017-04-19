/*
	Created: Helen
	Task: Adjust Outright Setting 
	DB: DBCUST/CustDB
	Date: 20160715
*/ 
--------------------- Adjust PT/Commision/Bet setting -------------------
UPDATE cs
	SET 
		-- PT
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
		-- Commission
		, playerdiscount = temp_comm.playerdiscount  
		, discount = temp_comm.discount
		, adiscount = temp_comm.adiscount
		, sdiscount =  temp_comm.sdiscount
		, groupa = temp_comm.groupa
		, groupb = temp_comm.groupb
		, groupc = temp_comm.groupc
		, groupd = temp_comm.groupd
		, groupe = temp_comm.groupe
		, groupf = temp_comm.groupf
		-- Bet setting
		, minbet = temp_pt.minbet
	    , maxbet = temp_pt.maxbet
	    
FROM custsetting cs WITH (UPDLOCK,ROWLOCK)
	CROSS APPLY	(SELECT cs_temp.custid
						, apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
						, minbet, maxbet
						, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
				FROM custsetting cs_temp (NOLOCK) 
				WHERE cs_temp.sporttype = 2 AND cs_temp.bettype = 1 AND cs.custid = cs_temp.custid
				) AS temp_pt
				 
	CROSS APPLY	(SELECT cs_temp_1.custid
						, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf
				FROM custsetting cs_temp_1 (NOLOCK) 
				WHERE cs_temp_1.sporttype = 1 AND cs_temp_1.bettype = 4 AND cs.custid = cs_temp_1.custid
				) AS temp_comm 


WHERE (cs.sporttype = 2 AND cs.bettype = 9999)
	-- PT ----
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
		 OR cs.isautolivempositiontaking <> temp_pt.isautolivempositiontaking
		-- Commission ---
		OR cs.playerdiscount <> temp_comm.playerdiscount
		OR cs.discount <> temp_comm.discount
		OR cs.adiscount <> temp_comm.adiscount
		OR cs. sdiscount <> temp_comm.sdiscount
		OR cs.groupa <> temp_comm.groupa
		OR cs.groupb <> temp_comm.groupb
		OR cs.groupc <> temp_comm.groupc
		OR cs.groupd <> temp_comm.groupd
		OR cs.groupe <> temp_comm.groupe
		OR cs.groupf <> temp_comm.groupf
		-- BET Setting ---
		OR cs.minbet <> temp_pt.minbet
		OR cs.maxbet <> temp_pt.maxbet
		)						
		
--2. custoverride
UPDATE cs
	SET 
		-- Update PT
		minpositiontaking = temp_pt.minpositiontaking
		, maxpositiontaking = temp_pt.maxpositiontaking
		, minlivepositiontaking = temp_pt.minlivepositiontaking
		, maxlivepositiontaking = temp_pt.maxlivepositiontaking
		
FROM custoverride cs WITH (ROWLOCK,UPDLOCK)
	CROSS APPLY	(SELECT cs_temp.custid, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking
				 FROM custoverride cs_temp (NOLOCK) 
				 WHERE cs_temp.sporttype = 2 AND cs_temp.bettype = 1 AND cs.custid = cs_temp.custid
			) AS temp_pt 

WHERE (cs.sporttype = 2 AND cs.bettype = 9999)
	AND ( cs.minpositiontaking <> temp_pt.minpositiontaking
		OR cs.maxpositiontaking <> temp_pt.maxpositiontaking
		OR cs.minlivepositiontaking <> temp_pt.minlivepositiontaking
		OR cs.maxlivepositiontaking <> temp_pt.maxlivepositiontaking
		)
--------------- END OF updating PT ----------------

	
	

