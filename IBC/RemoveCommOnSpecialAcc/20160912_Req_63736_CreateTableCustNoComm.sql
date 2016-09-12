/*
	Created: 201609012@Winnie
	Task: Create table CustNoComm - [Redmine: #63736]
	DB: DBCUST/CustDB
*/

USE [CustDB]
GO

CREATE TABLE [dbo].[CustNoComm](
	[CustID] [int] NOT NULL,
	[ModifiedDate] [date] NOT NULL,
	[Remark] [varchar](200) NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_CustNoComm] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustSetting_table]
) ON [CustSetting_table]

GO
ALTER TABLE [dbo].[CustNoComm] ADD  CONSTRAINT [DF_CustNoComm_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
