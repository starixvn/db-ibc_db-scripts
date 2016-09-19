/*
	Created by: Winnie
	Date: 2016-09-19
	Task: PRMS: Top Winners/ Winloss report: data of won tickets are not shown on report
	Regen data 9-Sep
*/
USE bodb_archive
GO
DELETE FROM DBRMS.bodb_rms.dbo.rmSumWinloss_OLD WHERE winlostdate='2016-09-05'
CREATE TABLE  #TemprmSumWinloss(
	[winlostdate] [smalldatetime] NOT NULL,
	[custid] [int] NOT NULL,
	[sporttype] [SMALLINT] NULL,
	[statusid] [tinyint] NOT NULL,
	[combo] [tinyint] NOT NULL,	
	[currency] [tinyint] NULL,
	[stake] [money] NULL,
	[winlost] [money] NULL,
	[company_stake] [money] NULL,
	[company_winlost] [money] NULL,
	[actualrate] [float] NULL,
	[odds] [smallmoney] NULL,
	[betcount] [int] NULL,
	[recommend] [int] NULL,
	ParlayType [tinyint] NULL	
	)
	CREATE TABLE #tmpbettrans(
	Transid BIGINT NOT NULL PRIMARY KEY,
	[winlostdate] [smalldatetime] NOT NULL,
	[custid] [int] NOT NULL,
	[statusid] [tinyint] NOT NULL,	
	[currency] [tinyint] NULL,
	[stake] [money] NULL,
	[winlost] [money] NULL,
	[actualrate] [float] NULL,
	[odds] [smallmoney] NULL,	
	[recommend] [int] NULL,
	bettype SMALLINT NULL,
	tpositiontaking SMALLMONEY NULL,
	hdp2 SMALLMONEY NULL,
	betcheck NVARCHAR(50) NULL,
	transid2 BIGINT NULL,
	modds   SMALLMONEY NULL,
	betteam NVARCHAR(10) NULL,
	refno BIGINT NOT NULL,
	matchId INT NULL,
	)
	CREATE TABLE #tmpbettransm(	
	refno BIGINT NOT NULL,
	sporttype INT NULL)
	
	INSERT INTO #tmpbettrans(
	Transid ,
	[winlostdate] ,
	[custid] ,	
	[statusid] ,	
	[currency],
	[stake] ,
	[winlost] ,	
	[actualrate],
	[odds] ,
	[recommend] ,
	bettype,
	tpositiontaking ,
	hdp2 ,
	betcheck,
	modds,
	betteam,
	refno,
	matchId
	)
	SELECT
	Transid ,
	[winlostdate] ,
	[custid] ,	
	[statusid] ,		
	[currency],
	[stake] ,
	[winlost] ,	
	[actualrate],
	[odds] ,	
	[recommend] ,
	bettype,
	tpositiontaking ,
	hdp2 ,
	betcheck,
	modds,
	betteam,
	refno,
	matchId
	FROM
	bettrans_bk b WITH(NOLOCK) 
	WHERE	b.winlostdate = '2016-09-05'
				AND matchid IN(9,29)
				AND bettype IN(9,29)				
				AND b.statusid IN (111,112,113)
				
	INSERT INTO #tmpbettransm(	refno ,	sporttype)
	SELECT a.refno,m.sporttype 
	FROM #tmpbettrans b (NOLOCK)
	INNER JOIN bettransm a(NOLOCK) ON a.refno=b.refno
	INNER JOIN match_bk m(NOLOCK) ON a.matchid=m.matchid	
	
	INSERT INTO #tmpbettransm(	refno ,	sporttype)
	SELECT a.refno,m.sporttype 
	FROM #tmpbettrans b (NOLOCK)
	INNER JOIN bodb02.dbo.bettransm a(NOLOCK) ON a.refno=b.refno
	INNER JOIN bodb02.dbo.match m(NOLOCK) ON a.matchid=m.matchid	
	
	INSERT INTO #tmpbettransm(	refno ,	sporttype)
	SELECT a.refno,m.sporttype 
	FROM #tmpbettrans b (NOLOCK)
	INNER JOIN bodb02.dbo.bettransm14 a(NOLOCK) ON a.refno=b.refno
	INNER JOIN bodb02.dbo.match14 m(NOLOCK) ON a.matchid=m.matchid	
	
UPDATE bb
	SET bb.transid2 = aa.transid2
	FROM #tmpbettrans  bb INNER JOIN 
	(SELECT b.refno,
	CASE WHEN COUNT(DISTINCT(sporttype))=1 THEN MIN(sporttype)
	WHEN COUNT(DISTINCT(sporttype))<>1 AND MIN(sporttype)=1 THEN  -3
	ELSE -1
	END AS transid2
	FROM #tmpbettransm b 		
	GROUP BY b.refno) aa ON aa.refno=bb.refno	
	INSERT INTO #TemprmSumWinloss (winlostdate
				,custid
				,sporttype
				,statusid
				,combo				
				,currency
				,stake
				,winlost
				,company_stake
				,company_winlost
				,actualrate
				,odds
				,betcount
				,recommend
				,ParlayType				
				)
		SELECT	 winlostdate
				,b.custid
				,transid2
				,statusid
				,CASE WHEN bettype=9 THEN RIGHT(betcheck,len(betcheck)-1) ELSE b.hdp2 END  AS combo				
				,currency
				,SUM(stake)
				,SUM(winlost)
				,SUM(stake*(1-tpositiontaking))
				,SUM(-(winlost-stake)*(1-tpositiontaking))
				,actualrate
				,SUM(modds)
				,count(1)
				,recommend 
				,CASE WHEN bettype=9 THEN 1 
					  WHEN bettype=29 AND betteam='1' THEN 2
					  ELSE 3 END AS ParlayType	
		FROM #tmpbettrans b			
		GROUP BY winlostdate, b.custid, transid2, statusid,  currency, actualrate,
				CASE WHEN bettype=9 THEN RIGHT(betcheck,len(betcheck)-1) ELSE b.hdp2 END,
				recommend,
				CASE WHEN bettype=9 THEN 1 
					  WHEN bettype=29 AND betteam='1' THEN 2
					  ELSE 3 END 					  

		INSERT INTO [bodb_RMS].[dbo].[rmSumWinloss_Old]
           ([winlostdate]
           ,[custid]
           ,[sporttype]
           ,[statusid]
           ,[combo]
           ,[username]
           ,[currency]
           ,[stake]
           ,[winlost]
           ,[company_stake]
           ,[company_winlost]
           ,[actualrate]
           ,[odds]
           ,[betcount]
           ,[recommend]
           ,[parlaytype])
         SELECT [winlostdate]
           ,a.custid
           ,[sporttype]
           ,[statusid]
           ,[combo]
           ,[username]
           ,a.currency
           ,[stake]
           ,[winlost]
           ,[company_stake]
           ,[company_winlost]
           ,[actualrate]
           ,[odds]
           ,[betcount]
           ,a.recommend
           ,[parlaytype]
           FROM #TemprmSumWinloss a
           INNER JOIN DBEXT.bodb02.dbo.Customer b (NOLOCK) ON a.custid=b.custid
		drop table #tmpbettrans
		drop table #TemprmSumWinloss
		drop table #tmpbettransm