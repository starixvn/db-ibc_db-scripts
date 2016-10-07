/*
	Created by: Winnie
	Date: 2016-09-29
	Task: PRMS: fix data conflict refno with racing RedmindID: #64996
	Regen data in table rmSumWinloss
*/
USE [bodb_RMS]
GO

/****** Object:  Table [dbo].[rmBettrans]    Script Date: 09/19/2016 13:39:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Truncate table [tmpbettransFixdata]

DECLARE @FromDate DATETIME
DECLARE @ToDate DATETIME

SELECT @FromDate= '2016-09-23'
SELECT @ToDate= '2016-09-25'
--SELECT @FromDate= '2016-10-01'
--SELECT @ToDate= '2016-10-02'
--drop table [tmpbettransFixdata]
	CREATE TABLE [dbo].[tmpbettransFixdata](
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
	matchId INT NULL
) ON [rmDATA]


CREATE NONCLUSTERED INDEX [IX_refno] ON [dbo].[tmpbettransFixdata] 
(
	[refno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


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


