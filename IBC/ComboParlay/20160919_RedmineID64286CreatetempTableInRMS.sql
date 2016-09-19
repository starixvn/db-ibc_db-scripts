/*
	Created by: Winnie
	Date: 2016-09-19
	Task: PRMS: Top Winners/ Winloss report: data of won tickets are not shown on report
	Regen data 9-Sep
*/
USE [bodb_RMS]
GO

/****** Object:  Table [dbo].[rmBettrans]    Script Date: 09/19/2016 13:39:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tmpbettransSep5](
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

GO
CREATE NONCLUSTERED INDEX [IX_refno] ON [dbo].[tmpbettransSep5] 
(
	[refno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


	INSERT INTO [tmpbettransSep5](
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
	DBARC.bodb_Archive.dbo.bettrans_bk b WITH(NOLOCK) 
	WHERE	b.winlostdate = '2016-09-05'
				AND matchid IN(9,29)
				AND bettype IN(9,29)				
				AND b.statusid IN (111,112,113)


