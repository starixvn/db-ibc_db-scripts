USE [bodb_Account]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.filegroups
		WHERE NAME = 'mcAutoProductDaily'
		)
BEGIN
	ALTER DATABASE [bodb_Account] ADD FILEGROUP [mcAutoProductDaily]

	ALTER DATABASE [bodb_Account] ADD FILE (
		NAME = N'mcAutoProductDaily'
		,FILENAME = N'D:\IBC_DB\bodb_Account\mcAutoProductDaily.ndf'
		,SIZE = 1024 MB
		,FILEGROWTH = 16 MB
		) TO FILEGROUP [mcAutoProductDaily]
END
GO

USE [bodb_Account]

IF OBJECT_ID('bodb_Account.dbo.mcAutoProductDaily') IS NOT NULL
BEGIN
	DROP TABLE dbo.mcAutoProductDaily
END

CREATE TABLE dbo.mcAutoProductDaily (
	rptDate DATETIME
	,ProductID INT
	,livestat INT
	,WinlossIBC MONEY NULL
	,TurnoverIBC MONEY NULL
	,BetCount INT NULL
	,PartnerAmtDue MONEY NULL CONSTRAINT [PK_mcAutoProductDaily] PRIMARY KEY NONCLUSTERED (rptDate ASC, ProductID ASC, livestat ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	) ON [mcAutoProductDaily]
GO


USE bodb_Staging

IF NOT EXISTS (
		SELECT *
		FROM sys.filegroups
		WHERE NAME = 'mcAutoProductDaily'
		)
BEGIN
	ALTER DATABASE bodb_Staging ADD FILEGROUP mcAutoProductDaily

	ALTER DATABASE [bodb_Staging] ADD FILE (
		NAME = N'mcAutoProductDaily'
		,FILENAME = N'D:\IBC_DB\bodb_Staging\mcAutoProductDaily.ndf'
		,SIZE = 1024 MB
		,FILEGROWTH = 16 MB
		) TO FILEGROUP mcAutoProductDaily
END
GO

IF OBJECT_ID('bodb_Staging.dbo.mcAutoProductDaily') IS NOT NULL
BEGIN
	DROP TABLE dbo.mcAutoProductDaily
END

CREATE TABLE dbo.mcAutoProductDaily (
	rptDate DATETIME
	,ProductID INT
	,livestat INT
	,WinlossIBC MONEY NULL
	,TurnoverIBC MONEY NULL
	,BetCount INT NULL
	,PartnerAmtDue MONEY NULL
	) ON [mcAutoProductDaily]
