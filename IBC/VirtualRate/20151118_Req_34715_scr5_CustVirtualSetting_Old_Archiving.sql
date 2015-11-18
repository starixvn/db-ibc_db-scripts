/*
	Description: Script to create table for archiving CustVirtualSetting data
	Creator: 20151118@Billy
	DB: DB05/bodb_Customer
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DB05/bodb_Customer	 --
---------------------------------------------------------------

USE [bodb_Customer]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustVirtualSetting_Old](
	[custid] [int] NOT NULL,
	[seqNo] [tinyint] NOT NULL,
	[bitmapVirtual] [binary](64) NOT NULL
 CONSTRAINT [PK_CustVirtualSetting] PRIMARY KEY CLUSTERED 
(
	[custid] ASC,
	[seqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Custsetting_table]
) ON [Custsetting_table]
GO