/*
	Description: Script to prepare CustVirtualSetting_History table and create trigger for insert data into it
	Creator: 20151118@Billy
	DB: DBTP/bodb_CustHistory & DB06/bodb02
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBTP/bodb_CustHistory --
---------------------------------------------------------------

-- Create files and filegroup for [CustVirtualSetting_History] table --
USE master
GO

ALTER DATABASE bodb_CustHistory
ADD FILEGROUP CustVirtualSetting_table
GO

ALTER DATABASE bodb_CustHistory
ADD FILE (
	NAME = bodb_CustVirtualSetting_01,
	FILENAME = 'X:\IBC_DB\bodb_history\bodb_CustVirtualSetting_01.ndf',
	SIZE = 2048KB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 65536KB
), (
	NAME = bodb_CustVirtualSetting_02,
	FILENAME = 'X:\IBC_DB\bodb_history\bodb_CustVirtualSetting_02.ndf',
	SIZE = 2048KB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 65536KB
)
TO FILEGROUP CustVirtualSetting_table
GO


-- Create history table [CustVirtualSetting_History] --

USE [bodb_CustHistory]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustVirtualSetting_History](
	[UpdateTime] [datetime] NOT NULL,
	[custid] [int] NOT NULL,
	[seqNo] [tinyint] NOT NULL,
	[bitmapVirtual] [binary](64) NOT NULL
) ON [CustVirtualSetting_table]

GO

ALTER TABLE [dbo].[CustVirtualSetting_History] ADD  CONSTRAINT [DF_CustVirtualSetting_History_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO

CREATE CLUSTERED INDEX [CIX_CustVirtualSetting_History] ON [dbo].[CustVirtualSetting_History] 
(
 [UpdateTime] DESC,
 [custid] ASC,
 [seqNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustVirtualSetting_table]
GO


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DB06/bodb02			 --
---------------------------------------------------------------

USE [bodb02]
GO

CREATE TRIGGER [dbo].[CustVirtualSetting_update] ON [dbo].[CustVirtualSetting]
AFTER UPDATE
AS
/*
	Created by: 20151118@Billy
	Task: Trigger for updating [CustVirtualSetting] table 
	DB: DBTP/bodb02

	Revisions: 
	
*/
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO bodb_CustHistory.dbo.CustVirtualSetting_History(
			custid, seqNo, bitmapVirtual)
	SELECT	custid, seqNo, bitmapVirtual
	FROM [DELETED]
END 
GO


