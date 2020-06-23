/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
	Created: 20200618@Malcolm
	Task: create filegroup and new table [Redmine: #135593]
	DB: DBSUM.bodb_Summary
*/

USE bodb_Summary
GO

-- add file group
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_20M05
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_20M06
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_20M07
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_20M08
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_20M09
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_20M10
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_20M11
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_20M12
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M01
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M02
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M03
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M04
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M05
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M06
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M07
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M08
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M09
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M10
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M11
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_21M12
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M01
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M02
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M03
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M04
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M05
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M06
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M07
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M08
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M09
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M10
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M11
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_22M12
ALTER DATABASE bodb_Summary ADD FILEGROUP sum_winloss_Extra_MAX

GO

-- add file name
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_20M05 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_20M05.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_20M05]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_20M06 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_20M06.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_20M06]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_20M07 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_20M07.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_20M07]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_20M08 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_20M08.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_20M08]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_20M09 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_20M09.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_20M09]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_20M10 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_20M10.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_20M10]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_20M11 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_20M11.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_20M11]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_20M12 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_20M12.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_20M12]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M01 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M01.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M01]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M02 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M02.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M02]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M03 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M03.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M03]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M04 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M04.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M04]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M05 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M05.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M05]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M06 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M06.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M06]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M07 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M07.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M07]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M08 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M08.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M08]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M09 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M09.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M09]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M10 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M10.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M10]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M11 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M11.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M11]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_21M12 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_21M12.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_21M12]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M01 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M01.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M01]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M02 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M02.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M02]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M03 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M03.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M03]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M04 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M04.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M04]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M05 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M05.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M05]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M06 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M06.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M06]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M07 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M07.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M07]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M08 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M08.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M08]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M09 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M09.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M09]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M10 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M10.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M10]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M11 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M11.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M11]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_22M12 , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_22M12.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [sum_winloss_Extra_22M12]
ALTER DATABASE bodb_Summary ADD FILE (NAME = sum_winloss_Extra_MAX   , FILENAME = 'E:\IBC_DB\bodb_Summary\sum_winloss_Extra\sum_winloss_Extra_MAX.ndf', SIZE = 3072 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP   [sum_winloss_Extra_MAX]

GO

-- Create partition function
CREATE PARTITION FUNCTION [PF_sum_winloss_Extra_Monthly] (SMALLDATETIME) AS 
RANGE LEFT FOR VALUES 
(
	N'2020-05-31',
	N'2020-06-30',
	N'2020-07-31',
	N'2020-08-31',
	N'2020-09-30',
	N'2020-10-31',
	N'2020-11-30',
	N'2020-12-31',
	N'2021-01-31',
	N'2021-02-28',
	N'2021-03-31',
	N'2021-04-30',
	N'2021-05-31',
	N'2021-06-30',
	N'2021-07-31',
	N'2021-08-31',
	N'2021-09-30',
	N'2021-10-31',
	N'2021-11-30',
	N'2021-12-31',
	N'2022-01-31',
	N'2022-02-28',
	N'2022-03-31',
	N'2022-04-30',
	N'2022-05-31',
	N'2022-06-30',
	N'2022-07-31',
	N'2022-08-31',
	N'2022-09-30',
	N'2022-10-31',
	N'2022-11-30',
	N'2022-12-31'
)

GO

-- Create partition schema
CREATE PARTITION SCHEME [PS_sum_winloss_Extra_Monthly] AS PARTITION [PF_sum_winloss_Extra_Monthly] TO 
(
    sum_winloss_Extra_20M05,
	sum_winloss_Extra_20M06,
	sum_winloss_Extra_20M07,
	sum_winloss_Extra_20M08,
	sum_winloss_Extra_20M09,
	sum_winloss_Extra_20M10,
	sum_winloss_Extra_20M11,
	sum_winloss_Extra_20M12,
	sum_winloss_Extra_21M01,
	sum_winloss_Extra_21M02,
	sum_winloss_Extra_21M03,
	sum_winloss_Extra_21M04,
	sum_winloss_Extra_21M05,
	sum_winloss_Extra_21M06,
	sum_winloss_Extra_21M07,
	sum_winloss_Extra_21M08,
	sum_winloss_Extra_21M09,
	sum_winloss_Extra_21M10,
	sum_winloss_Extra_21M11,
	sum_winloss_Extra_21M12,
	sum_winloss_Extra_22M01,
	sum_winloss_Extra_22M02,
	sum_winloss_Extra_22M03,
	sum_winloss_Extra_22M04,
	sum_winloss_Extra_22M05,
	sum_winloss_Extra_22M06,
	sum_winloss_Extra_22M07,
	sum_winloss_Extra_22M08,
	sum_winloss_Extra_22M09,
	sum_winloss_Extra_22M10,
	sum_winloss_Extra_22M11,
	sum_winloss_Extra_22M12,
	sum_winloss_Extra_MAX
)
GO

CREATE TABLE [dbo].[sum_winloss_extra](
	WinlostDate		SMALLDATETIME NOT NULL,
	CustId			INT	NOT NULL,
	ProductId       SMALLINT NOT NULL,
	Bettype			SMALLINT DEFAULT(0) NOT NULL,
	RoleId			INT,
	Recommend		INT,
	MRecommend		INT,
	SRecommend		INT,
	BetCount		INT	DEFAULT(0),
	Turnover		MONEY,
	NetTurnover		MONEY,
	TunroverNoDraw	MONEY,
	WinLoss			MONEY,
	AgWinLoss		MONEY,
	MAgWinLoss		MONEY,
	SAgWinLoss		MONEY,
	ExtraWinloss	MONEY,
	PlayerComm		MONEY,
	AgComm			MONEY,
	MAgComm			MONEY,
	SAgComm			MONEY,
	ExtraComm		MONEY,
	GrossComm		MONEY

 CONSTRAINT [PK_sum_winloss] PRIMARY KEY CLUSTERED (WinlostDate,CustId,ProductId,Bettype)ON [PS_sum_winloss_Extra_Monthly]
) ON [PS_sum_winloss_Extra_Monthly](WinlostDate)

