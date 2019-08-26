/*
	Created: 20190826@Helen
	Task: Delete wrong data and re-sync for bettype 29 - [Redmine: 119234]
	DB: DBxxx/bodb02
	
*/

USE bodb02 

GO
--------- PREPARATION ---------------------

DECLARE @matchid  INT = xxx

SELECT refno
INTO #Refno_list
FROM dbo.bettransm bm WITH(ROWLOCK)
WHERE matchid = @matchid
	AND NOT EXISTS (SELECT 1 FROM bettransm WITH(NOLOCK) WHERE refno = bm.refno AND statusID IN(1,101))

SELECT transid, refno
INTO #temp_bettrans_29
FROM bettrans b WITH(NOLOCK)
WHERE b.matchid = 29
	AND b.statusID NOT IN (101,102) 
	AND refno IN (SELECT refno FROM #Refno_list)

-------- DELETE BetParlayDetail, BetParlayResult -----------		 
DELETE pd
FROM BetParlayDetail pd
WHERE EXISTS (SELECT 1 FROM #Refno_list R1 WITH (NOLOCK) WHERE pd.Refno = R1.Refno)

DELETE pdr
FROM BetParlayResult pdr
WHERE EXISTS (SELECT 1 FROM #Refno_list R1 WITH (NOLOCK) WHERE pdr.Refno = R1.Refno)

-------- Sync data for bettype 29 ---------------
SELECT b.transid
		,SettlementTime  
		,statusID  
		,[status]  
		,winlostdate  
		,actual_stake 
		,betdaqid 							
		,ruben 
		,winlost 
		,awinlost 
		,mwinlost 
		,swinlost 
		,playercomm 
		,comm 
		,acomm 
		,scomm 
INTO #bettrans_tmp
FROM DBTXN.bodb02.dbo.bettrans b WITH (NOLOCK)
	INNER JOIN #temp_bettrans_29 s ON b.transid = s.transid
			
UPDATE b
	SET SettlementTime =  s.SettlementTime 
	,statusID  = s.statusID
	,[status]  = s.[status]
	,winlostdate = s.winlostdate 
	,actual_stake = s.actual_stake
	,betdaqid = s.betdaqid							
	,ruben = s.ruben
	,winlost = s.winlost
	,awinlost = s.awinlost
	,mwinlost = s.mwinlost
	,swinlost = s.swinlost
	,playercomm = s.playercomm
	,comm = s.comm
	,acomm = s.acomm
	,scomm = s.scomm
FROM bettrans b WITH (NOLOCK)	
	INNER JOIN #bettrans_tmp s
		ON b.transid = s.transid

		
	