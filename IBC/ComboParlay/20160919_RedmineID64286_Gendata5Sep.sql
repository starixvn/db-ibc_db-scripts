/*
	Created by: Winnie
	Date: 2016-09-19
	Task: PRMS: Top Winners/ Winloss report: data of won tickets are not shown on report
	Regen data 9-Sep
*/
USE bodb_RMS
GO

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
	
	CREATE TABLE #tmpbettransm(	
	refno BIGINT NOT NULL,
	sporttype INT NULL)	
	
	CREATE CLUSTERED INDEX [IX_refno] ON [dbo].#tmpbettransm 
	(
		[refno] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	GO
				
	INSERT INTO #tmpbettransm(	refno ,	sporttype)
	SELECT a.refno,m.sporttype 
	FROM [tmpbettransSep5] b (NOLOCK)
	INNER JOIN DBARC.bodb_Archive.dbo.bettransm a(NOLOCK) ON a.refno=b.refno
	INNER JOIN DBARC.bodb_Archive.dbo.match_bk m(NOLOCK) ON a.matchid=m.matchid	
	
	INSERT INTO #tmpbettransm(	refno ,	sporttype)
	SELECT a.refno,m.sporttype 
	FROM [tmpbettransSep5] b (NOLOCK)
	INNER JOIN bodb02.dbo.bettransm a(NOLOCK) ON a.refno=b.refno
	INNER JOIN bodb02.dbo.match m(NOLOCK) ON a.matchid=m.matchid	
	
	INSERT INTO #tmpbettransm(	refno ,	sporttype)
	SELECT a.refno,m.sporttype 
	FROM [tmpbettransSep5] b (NOLOCK)
	INNER JOIN bodb02.dbo.bettransm14 a(NOLOCK) ON a.refno=b.refno
	INNER JOIN bodb02.dbo.match14 m(NOLOCK) ON a.matchid=m.matchid	
	
UPDATE bb
	SET bb.transid2 = aa.transid2
	FROM [tmpbettransSep5]  bb INNER JOIN 
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
		FROM [tmpbettransSep5] b			
		GROUP BY winlostdate, b.custid, transid2, statusid,  currency, actualrate,
				CASE WHEN bettype=9 THEN RIGHT(betcheck,len(betcheck)-1) ELSE b.hdp2 END,
				recommend,
				CASE WHEN bettype=9 THEN 1 
					  WHEN bettype=29 AND betteam='1' THEN 2
					  ELSE 3 END 	
					  
	CREATE TABLE [dbo].[TMPrmSumWinloss_Old_Sep8](
	[winlostdate] [smalldatetime] NOT NULL,
	[custid] [int] NOT NULL,
	[sporttype] [smallint] NULL,
	[statusid] [tinyint] NOT NULL,
	[combo] [tinyint] NOT NULL,
	[username] [varchar](30) NOT NULL,
	[currency] [tinyint] NULL,
	[stake] [money] NULL,
	[winlost] [money] NULL,
	[company_stake] [money] NULL,
	[company_winlost] [money] NULL,
	[actualrate] [float] NULL,
	[odds] [smallmoney] NULL,
	[betcount] [int] NULL,
	[recommend] [int] NULL,
	[parlaytype] [tinyint] NULL
) ON [rmDATA]
	  
	  CREATE CLUSTERED INDEX [CIX_TMPrmSumWinloss_Old_Sep8] ON [dbo].TMPrmSumWinloss_Old_Sep8 
(
	[custid] ASC,
	[winlostdate] ASC,
	[sporttype] ASC,
	[statusid] ASC,
	[combo] ASC,
	ParlayType ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON rmDATA
GO


		INSERT INTO [bodb_RMS].[dbo].[TMPrmSumWinloss_Old_Sep8]
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
		--drop table #tmpbettrans
		drop table #TemprmSumWinloss
		drop table #tmpbettransm