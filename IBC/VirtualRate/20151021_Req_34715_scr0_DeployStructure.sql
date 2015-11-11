/*
	Created: 20151021@Billy
	Task: Deploy new virtual rate structure (UM time)
	DB: DBCUST.CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	--
-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBACC/bodb02		--
----------------------------------------------------------

USE [CustDB]
GO
  
SET ANSI_NULLS ON
GO
  
SET QUOTED_IDENTIFIER ON
GO
  
SET ANSI_PADDING ON
GO
  
-- Create table [dbo].[ProfileVirtualSetting]
CREATE TABLE [dbo].[ProfileVirtualSetting](
    [sporttype] [smallint] NULL,
    [bettype] [smallint] NULL,
    [islive] [bit] NULL,
    [profileID] [smallint] IDENTITY(1,1) NOT NULL,
    [seqNo]  AS ([profileID]/(65)+(1)),
 CONSTRAINT [PK_ProfileVirtualSetting] PRIMARY KEY CLUSTERED 
(
    [profileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
) ON [virtualrate_table]
GO
  
-- Create table [dbo].[CustVirtualSetting]
CREATE TABLE [dbo].[CustVirtualSetting](
    [custid] [int] NOT NULL,
    [seqNo] [tinyint] NOT NULL,
    [bitmapVirtual] [binary](64) NOT NULL,
 CONSTRAINT [PK_CustVirtualSetting] PRIMARY KEY CLUSTERED 
(
    [custid] ASC,
    [seqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
) ON [virtualrate_table]
GO
  
SET ANSI_PADDING OFF
GO
  
ALTER TABLE [dbo].[CustVirtualSetting] ADD  CONSTRAINT [DF_CustVirtualSetting_bitmapVirtual]  
    DEFAULT (0x00) FOR [bitmapVirtual]
GO