/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240730@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange - Support TW pull data by Subsidiary [RedmineID: #208468]		
*/


USE [bodb_3rdProduct]
GO

CREATE TYPE [dbo].[TVP_AgentList] AS TABLE(
	[AgentId] [int] NULL
)