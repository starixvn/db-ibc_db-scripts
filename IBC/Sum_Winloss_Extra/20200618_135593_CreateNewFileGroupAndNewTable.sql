/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
	Created: 20200618@Malcolm
	Task: create filegroup and new table [Redmine: #135593]
	DB: DBSUM.bodb_Summary
*/

ALTER DATABASE bodb_Summary ADD FILEGROUP Sum_Winloss_Extra

ALTER DATABASE bodb_Summary ADD FILE (
	NAME = Sum_Winloss_Extra,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER1\MSSQL\DATA\Sum_Winloss_Extra.ndf',
	SIZE = 40MB,
	FILEGROWTH = 10MB
) TO FILEGROUP Sum_Winloss_Extra

CREATE TABLE [dbo].[sum_winloss](
	winlostdate		DATETIME,
	custid			INT,
	bettype			SMALLINT,
	username		NVARCHAR(50),
	roleid			INT,
	recommend		INT,
	mrecommend		INT,
	srecommend		INT,
	turnover		MONEY,
	winlost			MONEY,
	awinlost		MONEY,
	mwinlost		MONEY,
	swinlost		MONEY,
	playercomm		MONEY,
	comm			MONEY,
	acomm			MONEY,
	scomm			MONEY,
	BetCount		INT,
	grosscomm		MONEY,
	sporttype		SMALLINT,
	netTurnover		MONEY,
	TunroverNoDraw	MONEY,
	ExtraWinloss	MONEY,
	ExtraComm		MONEY,
 CONSTRAINT [PK_sum_winloss] PRIMARY KEY CLUSTERED (winlostdate,custid,bettype)ON [SUM_WINLOSS_EXTRA]
) ON [SUM_WINLOSS_EXTRA]