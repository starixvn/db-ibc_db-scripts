  /*
	Task: Delete some UUS super line for sportbook and 3rd
	Create date: 2015-05-12
	Author: Susan
	Redmine link: https://redmine.nexcel.vn/issues/35687
	DB: DBTXN/CustDB
 */


-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	  @srecommend int	
	 ,@target VARCHAR(20)
	 ,@maxcustid bigint
AS
BEGIN
	SET NOCOUNT ON;

	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

	DELETE CustSuper WHERE custid = @srecommend AND custid<=@maxcustid  
	DELETE CustMaster WHERE custid in (select custid from custinfo with (NOLOCK) WHERE srecommend = @srecommend and roleid = 3) AND custid <=@maxcustid
	DELETE CustAgent WHERE custid in (select custid from custinfo with (NOLOCK) WHERE srecommend = @srecommend and roleid = 2) AND custid<=@maxcustid
	--DELETE subacc  
	DELETE custsub where custid in (select custid from custinfo with (NOLOCK) where srecommend = @srecommend and roleid in(4,3,2)) AND custid<=@maxcustid
    -- DELETE licensee superid  
    --DELETE Dep_CustSuper where custid = @custid   
	
	-- CREATE TMP TABLE 
	DECLARE @tmp_custID TABLE (CustID int)  
	INSERT INTO @tmp_custID  
	SELECT custID FROM custinfo WITH (NOLOCK) WHERE srecommend = @srecommend AND custid<=@maxcustid

	 
	DELETE custsetting where custid IN (SELECT custID FROM @tmp_custID)  
	DELETE CustSetting3rd where custid IN (SELECT custID FROM @tmp_custID)  
	--DELETE Dep_CustSetting where custid IN (SELECT custID FROM @tmp_custID)  
	--DELETE Dep_CustSetting3rd where custid IN (SELECT custID FROM @tmp_custID)  
   
	DELETE custoverride where custid IN (SELECT custID FROM @tmp_custID)  
	DELETE CustOverride3rd where custid IN (SELECT custID FROM @tmp_custID)  
	DELETE CustOverrideGame where custid IN (SELECT custID FROM @tmp_custID)  
   
    
	DELETE P2PGameSetting where custid IN (SELECT custID FROM @tmp_custID)  
	DELETE P2PGroupComm where custid IN (SELECT custID FROM @tmp_custID)
  
 --- Delete from balance debit/credit from DBTXN
   IF (@target = 'DBTRANS' AND @@SERVERNAME = 'DBTRANS')
   BEGIN
		 IF (SELECT COUNT(1) FROM bodb02.dbo.sysobjects WHERE name 
			IN ('BalanceCredit','BalanceDebit','BalancePendingCredit','BalancePendingDebit','BalanceCreditGame','BalanceDebitGame',
			'BalancePendingCreditGame','BalancePendingDebitGame') AND type = 'U') <> 8
		 RETURN
		  
		DELETE bodb02.dbo.BalanceCredit WHERE custid IN (SELECT custID FROM @tmp_custID)  
		DELETE bodb02.dbo.BalanceDebit  WHERE custid IN (SELECT custID FROM @tmp_custID)  
  
		DELETE bodb02.dbo.BalancePendingCredit WHERE custid IN (SELECT custID FROM @tmp_custID)  
		DELETE bodb02.dbo.BalancePendingDebit  WHERE custid IN (SELECT custID FROM @tmp_custID)  
   
		DELETE bodb02.dbo.BalanceCreditGame WHERE custid IN (SELECT custID FROM @tmp_custID)  
		DELETE bodb02.dbo.BalanceDebitGame  WHERE custid IN (SELECT custID FROM @tmp_custID)  
  
		DELETE bodb02.dbo.BalancePendingCreditGame WHERE custid IN (SELECT custID FROM @tmp_custID)  
		DELETE bodb02.dbo.BalancePendingDebitGame  WHERE custid IN (SELECT custID FROM @tmp_custID) 
  END

  ---- Delete from custinfo and customer table
    DELETE custinfo where custid in (select custid from  @tmp_custID  )   
	DELETE customer where custid in (select custid from  @tmp_custID  )   

END  
  


GO-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


-- BEGIN STEP 2: RUN THIS SCRIPT AT REPLICATE DB -----
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY, username varchar(50), isfinished bit default(0))
	DECLARE @srecommend INT,@username varchar(50),  @maxcustid bigint

	SELECT @maxcustid=xxx   ---input maxcustid here

---inser super in to #supers:
	INSERT INTO #Supers
	SELECT  custid,
		    username,
		    0
	FROM Custinfo WITH(NOLOCK) 
	WHERE custid IN (	15322739	,	--	SuperTestAuto1
						17142333	,	--	SupertestL01
						15888425	,	--	supertest9W
						15944823	,	--	supertest2copy
						15962804	,	--	supertestCA
						14227263	,	--	supertestUAT2
						14228860	,	--	supertestUAT3
						14228900	,	--	supertestUAT4
						16278140	,	--	SupertestPA20
						14697312	,	--	supertestuat6
						14697576	,	--	supertestlive3
						14746634	,	--	supertestlive4
						16364028	,	--	supertestliveG
						16364897	,	--	supertest01
						17728808	,	--	supertestlive1a
						15911748	,	--	SuperTestCSB
						15918155	,	--	supertestOL
						15918962	,	--	supertestuatM
						16015204	,	--	SupertestPA13
						16015452	,	--	supertestliveC
						16016140	,	--	supertestLIVE1copy
						14428995	,	--	supertest_H_01
						14429049	,	--	supertest_H_02
						14429100	,	--	supertest_H_03
						14429155	,	--	supertestH01
						14429967	,	--	supertestH02
						15744747	,	--	Supertest20081407
						15744790	,	--	Supertest20081409
						15752801	,	--	SupertestPA9
						15753114	,	--	SuperTestPA10
						15755621	,	--	SuperTestDI
						15755865	,	--	SuperTestDI1
						15520691	,	--	SuperTestBR
						15521557	,	--	SuperTestHF
						15523476	,	--	SupertestLC23
						14782179	,	--	supertest30
						14854095	,	--	SuperTestIN2
						15811767	,	--	supertestliveA
						16664525	,	--	supertestliveH
						16714356	,	--	supertestB01
						16714367	,	--	supertestB03
						16802384	,	--	SupertestHR01
						14562299	,	--	SupertestPA4
						14562498	,	--	SupertestPA3
						14565247	,	--	supertestSC3
						17414825	,	--	Supertestmt3000
						15786745	,	--	supertestLIVE9
						15804216	,	--	supertestuatH
						15861037	,	--	supertestuatI
						16236466	,	--	supertest_A_06
						16236535	,	--	supertest_A_05
						16684348	,	--	supertestlivei
						16693379	,	--	supertestA01
						16693403	,	--	supertestA0101
						14444039	,	--	SupertestJ23
						14444654	,	--	SupertestJ24
						14444827	,	--	SupertestJ26
						14500502	,	--	supertestlive5
						14500923	,	--	supertestlive6
						14543886	,	--	SuperTest92
						14553628	,	--	SuperTestEKeno
						16168290	,	--	supertestuatN
						14396143	,	--	SupertestJ20
						14396195	,	--	SupertestJ21
						14396200	,	--	SupertestJ22
						14430133	,	--	supertestH03
						14430204	,	--	supertestH04
						16194501	,	--	supertest_A_01
						14698346	,	--	SuperTestss
						14703872	,	--	supertestuat7
						14706124	,	--	supertestAD
						14706366	,	--	supertestuat8
						14707373	,	--	supertestuat9
						14712574	,	--	supertestuatA
						15561873	,	--	supertestuatF
						15628251	,	--	supertestRK
						15866535	,	--	SupertestCS
						15866712	,	--	supertestuatJ
						15867330	,	--	SupertestCSS
						15867351	,	--	SupertestCSA4
						15867537	,	--	supertestuatK
						15867800	,	--	supertestliveB
						15868425	,	--	supertestuatL
						17083289	,	--	supertestuatQ
						17085294	,	--	supertestuatR
						17091295	,	--	supertestliveJ
						17125794	,	--	Supertestmt00
						17126556	,	--	Supertestmt001
						16138845	,	--	supertestliveD
						17522882	,	--	supertestgr03
						17523257	,	--	supertestgr04
						17549216	,	--	supertestLCUAT
						17549233	,	--	supertestuatS
						17551188	,	--	supertestgr05
						17551267	,	--	supertestgr06
						17551646	,	--	supertestgr07
						17551977	,	--	supertestgr08
						17552005	,	--	supertestgr09
						17552031	,	--	supertestgr10
						17552037	,	--	supertestgr11
						15506751	,	--	SupertestSU1
						15514606	,	--	supertestuatB
						15514836	,	--	supertestuatC
						15551684	,	--	SuperTestX1
						15553704	,	--	supertestuatD
						15555430	,	--	supertestuatE
						15560872	,	--	SupertestJ88
						15560947	,	--	SupertestPA8
						15582246	,	--	Supertest010814
						15582251	,	--	Supertest010815
						15622769	,	--	supertestlc1
						15622821	,	--	supertestlc2
						16745744	,	--	supertestB10
						16746817	,	--	supertestB11
						16754550	,	--	supertestB12
						16754620	,	--	supertestB13
						16754627	,	--	supertestB14
						17304905	,	--	Supertestmt100
						17304917	,	--	supertestliveK
						17305096	,	--	Supertestmt200
						17327554	,	--	Supertestmt300
						17327566	,	--	Supertestmt400
						17487732	,	--	SupertestKN1
						14816180	,	--	supertest31
						15581273	,	--	Supertest18121
						15581610	,	--	SupertestSC1
						15581636	,	--	Supertest010810
						15581656	,	--	SupertestSC2
						15581734	,	--	SupertestSC4
						15581854	,	--	Supertest010811
						15581878	,	--	Supertest010812
						15582083	,	--	Supertest010813
						17594555	,	--	supertestuatScopy
						17601814	,	--	supertestliveM
						17601849	,	--	supertestlivecopy2
						17617839	,	--	supertestlivecopy3
						17646550	,	--	Supertestmartin1304
						17655384	,	--	supertestliveN
						17655575	,	--	supertestliveO
						17655672	,	--	supertestCPro
						17655738	,	--	supertestliveP
						17656129	,	--	supertestliveQ
						17656178	,	--	supertestliveR
						17656912	,	--	supertestliveS
						17657011	,	--	supertestliveT
						17658819	,	--	supertestliveO1
						17665442	,	--	supertestgr15
						17665642	,	--	supertestgr21
						17672589	,	--	supertestliveU
						17673055	,	--	supertestgr014
						17674172	,	--	Supertestmartin1604
						15628181	,	--	SupertestLC10
						15666442	,	--	supertestUATcopy
						15666450	,	--	supertestuatG
						15674109	,	--	supertestLIVE7
						15674177	,	--	supertestBRD
						15674228	,	--	SupertestBR1
						15674310	,	--	SuperTestBRA
						15674474	,	--	supertestlivecopy
						15676669	,	--	supertestLIVE8
						15737214	,	--	Supertest19081401
						15737368	,	--	Supertest19081402
						15737440	,	--	Supertest19081403
						15737539	,	--	Supertest1908140204
						15737576	,	--	Supertest19081405
						15738997	,	--	supertestD
						15744008	,	--	Supertest20081401
						15744016	,	--	Supertest20081402
						15744053	,	--	Supertest20081403
						15744225	,	--	Supertest9
						15744737	,	--	Supertest20081406
						14380086	,	--	supertestLiveCasino
						14380322	,	--	SupertestJ15
						14382412	,	--	SupertestJ16
						14382562	,	--	SupertestJ17
						14382581	,	--	SupertestJ18
						14771848	,	--	supertestH09
						14771849	,	--	SupertestPA5
						14771863	,	--	supertestH10
						14771869	,	--	SupertestPA6
						14771870	,	--	supertestH11
						14771918	,	--	supertestH12
						14772526	,	--	SupertestPA7
						15692142	,	--	Supertest6
						15693814	,	--	supertest8
						15516339	,	--	SupertestS
						16948215	,	--	Supertestmt01
						16949221	,	--	Supertestmt02
						16970766	,	--	Supertestmt03
						16970775	,	--	Supertestmt04
						17556233	,	--	supertestgr12
						17556315	,	--	supertestgr13
						17556619	,	--	supertestgr16
						17556631	,	--	supertestgr17
						17556740	,	--	supertestgr19
						17556769	,	--	supertestgr20
						17556848	,	--	supertestgr23
						17557445	,	--	supertestliveL
						17557524	,	--	supertestgr18
						16227893	,	--	supertestLCC
						16227957	,	--	SupertestPA15
						16228015	,	--	SupertestPA16
						16228093	,	--	SupertestPA17
						16228263	,	--	SupertestPA18
						16235380	,	--	supertest_A_02
						16235413	,	--	supertest_A_03
						16235895	,	--	supertest_A_04
						16252070	,	--	supertestlivecopy1
						16252273	,	--	supertestliveE
						16252458	,	--	supertestKN
						16252485	,	--	supertestliveF
						16529093	,	--	supertest09
						16529590	,	--	supertest13
						16529705	,	--	supertest15
						16529715	,	--	supertest016
						16552967	,	--	supertest20
						16553006	,	--	supertest023
						16553181	,	--	supertest024
						14172614	,	--	SupertestPT
						14172959	,	--	SupertestPA1
						14179926	,	--	supertestUAT
						14182120	,	--	supertestLIVE
						14189267	,	--	SupertestJ14
						14196155	,	--	supertestUAT1
						14197609	,	--	SupertestBob1
						14197736	,	--	supertestBo1
						14216208	,	--	supertestLIVE1
						14217508	,	--	SupertestPA2
						14241534	,	--	supertestUAT5
						14242937	,	--	supertestLIVE2
						14300291	,	--	SupertestLCS1
						14306371	,	--	supertestvs
						14306440	,	--	supertest_VS_H_01
						14306450	,	--	SupertestVSC
						14306677	,	--	supertest_VS_H02
						14306753	,	--	supertest_VS_H_02
						14307499	,	--	SupertestLCS2
						14373367	,	--	SupertestLCLog
						16402282	,	--	supertestA02
						16402288	,	--	supertestA03
						16402294	,	--	supertestA04
						16421501	,	--	supertestA05
						16421571	,	--	supertestA06
						16421835	,	--	supertestA07
						16421897	,	--	supertestA08
						16421903	,	--	supertestA09
						16422559	,	--	supertestuatO
						16477952	,	--	supertestKeno
						16485918	,	--	supertest0101
						16491799	,	--	supertest02
						16491802	,	--	supertest03
						16491966	,	--	supertest04
						16492059	,	--	supertest0103
						16492067	,	--	supertest0104
						16492166	,	--	supertest0105
						16492180	,	--	supertest0106
						16492821	,	--	supertestlcs
						16493140	,	--	supertestlcsqqq
						16493287	,	--	supertestlcsrrr
						16493380	,	--	supertestlcstttc
						16517274	,	--	supertest05
						16519355	,	--	supertest06
						16519394	,	--	supertest07
						16528321	,	--	supertest08
						16634594	,	--	supertestB02
						16634615	,	--	supertestC01
						16634627	,	--	supertestC02
						16634639	,	--	supertestC03
						16634662	,	--	supertestC04
						16634791	,	--	supertestC05
						16634805	,	--	supertestD01
						16634823	,	--	supertestD02
						16635056	,	--	supertestnewLCS
						16635127	,	--	supertestnewLCS1
						16635146	,	--	supertestnewLCS2
						16635160	,	--	supertestnewLCS3
						16635231	,	--	supertestnewLCS4
						16635353	,	--	supertestD04
						16641434	,	--	supertestC06
						16641448	,	--	supertestC07
						16641460	,	--	supertestC08
						16641480	,	--	supertestC09
						16641490	,	--	supertestC10
						16641512	,	--	supertestD0101
						16641644	,	--	supertestD0102
						16641660	,	--	supertestD0103
						16641709	,	--	supertestD0105
						16641727	,	--	supertestD0106
						16642967	,	--	supertestlcsnew
						16643007	,	--	supertestD10
						16643086	,	--	supertestD0107
						16643531	,	--	supertestD0108
						16649131	,	--	supertestD0109
						16649133	,	--	supertestlivecasino01
						16649134	,	--	supertestD0201
						16649138	,	--	supertestD0202
						16649145	,	--	supertestD0301
						16649152	,	--	supertestD0203
						16649165	,	--	supertestD0204
						16649195	,	--	supertestD0205
						16649203	,	--	supertestD0206
						16649210		--	supertestD0207
	
				)
	AND Roleid=4
	AND currency=20
	AND custid<=@maxcustid

	WHILE (1 = 1)
	BEGIN
		UPDATE TOP (1) #Supers
		SET isfinished = 1
			,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09  @srecommend = @srecommend,  @maxcustid=@maxcustid, @target = 'REPLICATED'  			
	
	WAITFOR DELAY '00:00:00.280'
	END

	DROP TABLE #Supers
GO

---- End of step 2

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
CREATE TABLE #Supers ( custid INT , username  varchar(50) , isfinished bit default(0))
	DECLARE @currency int ,@srecommend int , @maxcustid int

	SELECT @maxcustid=xxx   --input maxcustid here
	---inser super in to #supers:
	INSERT INTO #Supers
	SELECT  custid,
			username,
			 0
	FROM Custinfo WITH(NOLOCK) 
	WHERE custid in	(	15322739	,	--	SuperTestAuto1
						17142333	,	--	SupertestL01
						15888425	,	--	supertest9W
						15944823	,	--	supertest2copy
						15962804	,	--	supertestCA
						14227263	,	--	supertestUAT2
						14228860	,	--	supertestUAT3
						14228900	,	--	supertestUAT4
						16278140	,	--	SupertestPA20
						14697312	,	--	supertestuat6
						14697576	,	--	supertestlive3
						14746634	,	--	supertestlive4
						16364028	,	--	supertestliveG
						16364897	,	--	supertest01
						17728808	,	--	supertestlive1a
						15911748	,	--	SuperTestCSB
						15918155	,	--	supertestOL
						15918962	,	--	supertestuatM
						16015204	,	--	SupertestPA13
						16015452	,	--	supertestliveC
						16016140	,	--	supertestLIVE1copy
						14428995	,	--	supertest_H_01
						14429049	,	--	supertest_H_02
						14429100	,	--	supertest_H_03
						14429155	,	--	supertestH01
						14429967	,	--	supertestH02
						15744747	,	--	Supertest20081407
						15744790	,	--	Supertest20081409
						15752801	,	--	SupertestPA9
						15753114	,	--	SuperTestPA10
						15755621	,	--	SuperTestDI
						15755865	,	--	SuperTestDI1
						15520691	,	--	SuperTestBR
						15521557	,	--	SuperTestHF
						15523476	,	--	SupertestLC23
						14782179	,	--	supertest30
						14854095	,	--	SuperTestIN2
						15811767	,	--	supertestliveA
						16664525	,	--	supertestliveH
						16714356	,	--	supertestB01
						16714367	,	--	supertestB03
						16802384	,	--	SupertestHR01
						14562299	,	--	SupertestPA4
						14562498	,	--	SupertestPA3
						14565247	,	--	supertestSC3
						17414825	,	--	Supertestmt3000
						15786745	,	--	supertestLIVE9
						15804216	,	--	supertestuatH
						15861037	,	--	supertestuatI
						16236466	,	--	supertest_A_06
						16236535	,	--	supertest_A_05
						16684348	,	--	supertestlivei
						16693379	,	--	supertestA01
						16693403	,	--	supertestA0101
						14444039	,	--	SupertestJ23
						14444654	,	--	SupertestJ24
						14444827	,	--	SupertestJ26
						14500502	,	--	supertestlive5
						14500923	,	--	supertestlive6
						14543886	,	--	SuperTest92
						14553628	,	--	SuperTestEKeno
						16168290	,	--	supertestuatN
						14396143	,	--	SupertestJ20
						14396195	,	--	SupertestJ21
						14396200	,	--	SupertestJ22
						14430133	,	--	supertestH03
						14430204	,	--	supertestH04
						16194501	,	--	supertest_A_01
						14698346	,	--	SuperTestss
						14703872	,	--	supertestuat7
						14706124	,	--	supertestAD
						14706366	,	--	supertestuat8
						14707373	,	--	supertestuat9
						14712574	,	--	supertestuatA
						15561873	,	--	supertestuatF
						15628251	,	--	supertestRK
						15866535	,	--	SupertestCS
						15866712	,	--	supertestuatJ
						15867330	,	--	SupertestCSS
						15867351	,	--	SupertestCSA4
						15867537	,	--	supertestuatK
						15867800	,	--	supertestliveB
						15868425	,	--	supertestuatL
						17083289	,	--	supertestuatQ
						17085294	,	--	supertestuatR
						17091295	,	--	supertestliveJ
						17125794	,	--	Supertestmt00
						17126556	,	--	Supertestmt001
						16138845	,	--	supertestliveD
						17522882	,	--	supertestgr03
						17523257	,	--	supertestgr04
						17549216	,	--	supertestLCUAT
						17549233	,	--	supertestuatS
						17551188	,	--	supertestgr05
						17551267	,	--	supertestgr06
						17551646	,	--	supertestgr07
						17551977	,	--	supertestgr08
						17552005	,	--	supertestgr09
						17552031	,	--	supertestgr10
						17552037	,	--	supertestgr11
						15506751	,	--	SupertestSU1
						15514606	,	--	supertestuatB
						15514836	,	--	supertestuatC
						15551684	,	--	SuperTestX1
						15553704	,	--	supertestuatD
						15555430	,	--	supertestuatE
						15560872	,	--	SupertestJ88
						15560947	,	--	SupertestPA8
						15582246	,	--	Supertest010814
						15582251	,	--	Supertest010815
						15622769	,	--	supertestlc1
						15622821	,	--	supertestlc2
						16745744	,	--	supertestB10
						16746817	,	--	supertestB11
						16754550	,	--	supertestB12
						16754620	,	--	supertestB13
						16754627	,	--	supertestB14
						17304905	,	--	Supertestmt100
						17304917	,	--	supertestliveK
						17305096	,	--	Supertestmt200
						17327554	,	--	Supertestmt300
						17327566	,	--	Supertestmt400
						17487732	,	--	SupertestKN1
						14816180	,	--	supertest31
						15581273	,	--	Supertest18121
						15581610	,	--	SupertestSC1
						15581636	,	--	Supertest010810
						15581656	,	--	SupertestSC2
						15581734	,	--	SupertestSC4
						15581854	,	--	Supertest010811
						15581878	,	--	Supertest010812
						15582083	,	--	Supertest010813
						17594555	,	--	supertestuatScopy
						17601814	,	--	supertestliveM
						17601849	,	--	supertestlivecopy2
						17617839	,	--	supertestlivecopy3
						17646550	,	--	Supertestmartin1304
						17655384	,	--	supertestliveN
						17655575	,	--	supertestliveO
						17655672	,	--	supertestCPro
						17655738	,	--	supertestliveP
						17656129	,	--	supertestliveQ
						17656178	,	--	supertestliveR
						17656912	,	--	supertestliveS
						17657011	,	--	supertestliveT
						17658819	,	--	supertestliveO1
						17665442	,	--	supertestgr15
						17665642	,	--	supertestgr21
						17672589	,	--	supertestliveU
						17673055	,	--	supertestgr014
						17674172	,	--	Supertestmartin1604
						15628181	,	--	SupertestLC10
						15666442	,	--	supertestUATcopy
						15666450	,	--	supertestuatG
						15674109	,	--	supertestLIVE7
						15674177	,	--	supertestBRD
						15674228	,	--	SupertestBR1
						15674310	,	--	SuperTestBRA
						15674474	,	--	supertestlivecopy
						15676669	,	--	supertestLIVE8
						15737214	,	--	Supertest19081401
						15737368	,	--	Supertest19081402
						15737440	,	--	Supertest19081403
						15737539	,	--	Supertest1908140204
						15737576	,	--	Supertest19081405
						15738997	,	--	supertestD
						15744008	,	--	Supertest20081401
						15744016	,	--	Supertest20081402
						15744053	,	--	Supertest20081403
						15744225	,	--	Supertest9
						15744737	,	--	Supertest20081406
						14380086	,	--	supertestLiveCasino
						14380322	,	--	SupertestJ15
						14382412	,	--	SupertestJ16
						14382562	,	--	SupertestJ17
						14382581	,	--	SupertestJ18
						14771848	,	--	supertestH09
						14771849	,	--	SupertestPA5
						14771863	,	--	supertestH10
						14771869	,	--	SupertestPA6
						14771870	,	--	supertestH11
						14771918	,	--	supertestH12
						14772526	,	--	SupertestPA7
						15692142	,	--	Supertest6
						15693814	,	--	supertest8
						15516339	,	--	SupertestS
						16948215	,	--	Supertestmt01
						16949221	,	--	Supertestmt02
						16970766	,	--	Supertestmt03
						16970775	,	--	Supertestmt04
						17556233	,	--	supertestgr12
						17556315	,	--	supertestgr13
						17556619	,	--	supertestgr16
						17556631	,	--	supertestgr17
						17556740	,	--	supertestgr19
						17556769	,	--	supertestgr20
						17556848	,	--	supertestgr23
						17557445	,	--	supertestliveL
						17557524	,	--	supertestgr18
						16227893	,	--	supertestLCC
						16227957	,	--	SupertestPA15
						16228015	,	--	SupertestPA16
						16228093	,	--	SupertestPA17
						16228263	,	--	SupertestPA18
						16235380	,	--	supertest_A_02
						16235413	,	--	supertest_A_03
						16235895	,	--	supertest_A_04
						16252070	,	--	supertestlivecopy1
						16252273	,	--	supertestliveE
						16252458	,	--	supertestKN
						16252485	,	--	supertestliveF
						16529093	,	--	supertest09
						16529590	,	--	supertest13
						16529705	,	--	supertest15
						16529715	,	--	supertest016
						16552967	,	--	supertest20
						16553006	,	--	supertest023
						16553181	,	--	supertest024
						14172614	,	--	SupertestPT
						14172959	,	--	SupertestPA1
						14179926	,	--	supertestUAT
						14182120	,	--	supertestLIVE
						14189267	,	--	SupertestJ14
						14196155	,	--	supertestUAT1
						14197609	,	--	SupertestBob1
						14197736	,	--	supertestBo1
						14216208	,	--	supertestLIVE1
						14217508	,	--	SupertestPA2
						14241534	,	--	supertestUAT5
						14242937	,	--	supertestLIVE2
						14300291	,	--	SupertestLCS1
						14306371	,	--	supertestvs
						14306440	,	--	supertest_VS_H_01
						14306450	,	--	SupertestVSC
						14306677	,	--	supertest_VS_H02
						14306753	,	--	supertest_VS_H_02
						14307499	,	--	SupertestLCS2
						14373367	,	--	SupertestLCLog
						16402282	,	--	supertestA02
						16402288	,	--	supertestA03
						16402294	,	--	supertestA04
						16421501	,	--	supertestA05
						16421571	,	--	supertestA06
						16421835	,	--	supertestA07
						16421897	,	--	supertestA08
						16421903	,	--	supertestA09
						16422559	,	--	supertestuatO
						16477952	,	--	supertestKeno
						16485918	,	--	supertest0101
						16491799	,	--	supertest02
						16491802	,	--	supertest03
						16491966	,	--	supertest04
						16492059	,	--	supertest0103
						16492067	,	--	supertest0104
						16492166	,	--	supertest0105
						16492180	,	--	supertest0106
						16492821	,	--	supertestlcs
						16493140	,	--	supertestlcsqqq
						16493287	,	--	supertestlcsrrr
						16493380	,	--	supertestlcstttc
						16517274	,	--	supertest05
						16519355	,	--	supertest06
						16519394	,	--	supertest07
						16528321	,	--	supertest08
						16634594	,	--	supertestB02
						16634615	,	--	supertestC01
						16634627	,	--	supertestC02
						16634639	,	--	supertestC03
						16634662	,	--	supertestC04
						16634791	,	--	supertestC05
						16634805	,	--	supertestD01
						16634823	,	--	supertestD02
						16635056	,	--	supertestnewLCS
						16635127	,	--	supertestnewLCS1
						16635146	,	--	supertestnewLCS2
						16635160	,	--	supertestnewLCS3
						16635231	,	--	supertestnewLCS4
						16635353	,	--	supertestD04
						16641434	,	--	supertestC06
						16641448	,	--	supertestC07
						16641460	,	--	supertestC08
						16641480	,	--	supertestC09
						16641490	,	--	supertestC10
						16641512	,	--	supertestD0101
						16641644	,	--	supertestD0102
						16641660	,	--	supertestD0103
						16641709	,	--	supertestD0105
						16641727	,	--	supertestD0106
						16642967	,	--	supertestlcsnew
						16643007	,	--	supertestD10
						16643086	,	--	supertestD0107
						16643531	,	--	supertestD0108
						16649131	,	--	supertestD0109
						16649133	,	--	supertestlivecasino01
						16649134	,	--	supertestD0201
						16649138	,	--	supertestD0202
						16649145	,	--	supertestD0301
						16649152	,	--	supertestD0203
						16649165	,	--	supertestD0204
						16649195	,	--	supertestD0205
						16649203	,	--	supertestD0206
						16649210		--	supertestD0207
	
				)
		AND Roleid=4	
		AND currency=20
		AND custid<=@maxcustid
		
	WHILE (1 = 1)
	BEGIN
		UPDATE TOP (1) #Supers
		SET isfinished = 1,
			@srecommend = custid	
		WHERE isfinished = 0
	
		IF @@ROWCOUNT = 0 BREAK
			
		EXEC dbo.Acc_ExecRep_Cust_09  @srecommend = @srecommend, @maxcustid=@maxcustid, @target = 'DBTRANS'  			
	
		WAITFOR DELAY '00:00:00.280'
	END

	DROP TABLE #Supers
GO


---- End of step 3

