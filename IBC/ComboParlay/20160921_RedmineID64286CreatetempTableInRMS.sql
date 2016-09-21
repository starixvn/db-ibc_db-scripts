/*
	Created by: Winnie
	Date: 2016-09-21
	Task: PRMS: Top Winners/ Winloss report: data of won tickets are not shown on report
	Regen data in table rmSumWinloss
*/
USE [bodb_RMS]
GO

/****** Object:  Table [dbo].[rmBettrans]    Script Date: 09/19/2016 13:39:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Truncate table [tmpbettransFixdata]

DECLARE @FromDate DATETIME
DECLARE @ToDate DATETIME

SELECT @FromDate= MIN(winlostdate) FROM rmSumWinloss(NOLOCK)
SELECT @ToDate=  MAX(winlostdate) FROM rmSumWinloss(NOLOCK)
	--INSERT INTO [tmpbettransFixdata](
	--Transid ,
	--[winlostdate] ,
	--[custid] ,	
	--[statusid] ,	
	--[currency],
	--[stake] ,
	--[winlost] ,	
	--[actualrate],
	--[odds] ,
	--[recommend] ,
	--bettype,
	--tpositiontaking ,
	--hdp2 ,
	--betcheck,
	--modds,
	--betteam,
	--refno,
	--matchId
	--)
	--SELECT
	--Transid ,
	--[winlostdate] ,
	--[custid] ,	
	--[statusid] ,		
	--[currency],
	--[stake] ,
	--[winlost] ,	
	--[actualrate],
	--[odds] ,	
	--[recommend] ,
	--bettype,
	--tpositiontaking ,
	--hdp2 ,
	--betcheck,
	--modds,
	--betteam,
	--refno,
	--matchId
	--FROM
	--DBARC.bodb_Archive.dbo.bettrans_bk b WITH(NOLOCK) 
	--WHERE	b.winlostdate between @Fromdate and @Todate
	--			AND matchid IN(9,29)
	--			AND bettype IN(9,29)				
	--			AND b.statusid IN (111,112,113)
				
	INSERT INTO [tmpbettransFixdata](
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
	bodb02.dbo.bettrans14 b WITH(NOLOCK) 
	WHERE	b.winlostdate between @Fromdate and @Todate
				AND matchid IN(9,29)
				AND bettype IN(9,29)				
				AND b.statusid IN (111,112,113)


