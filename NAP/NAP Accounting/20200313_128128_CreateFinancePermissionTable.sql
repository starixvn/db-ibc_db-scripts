/*
	Created: 20200313@Malcolm
		Task:  Arrange detail permission for finance account [RedmineId : #128128]
		DB: DBCUST/CustDB
*/

USE [CustDB]
GO

CREATE TABLE [dbo].[Acc_FinancePermission](
	[GroupId] [smallint] NOT NULL,
	[CustId] [INT] NOT NULL,
	[RoleId] [tinyint] NULL,
	[IsView] [bit] NOT NULL,
 CONSTRAINT [PK_Acc_FinancePermission] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[CustId] ASC
)
) ON [DATA]
GO


