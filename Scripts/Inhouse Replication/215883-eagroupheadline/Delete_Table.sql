/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250115@Lewis	
	Task: In-House
	DB: 
	
	Revisions:
		- 20250115@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'EaGroupHeadline_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[EaGroupHeadline_Del_InHouse]
	(
		[GroupHeadlineId] [INT] NOT NULL
		,[GroupId] [INT] NOT NULL
		,[GroupName] [VARCHAR](100) NOT NULL
		,[SiteId] [INT] NOT NULL
		,[ExchangeId] [INT] NOT NULL
		) ON [DATA]

	ALTER TABLE [dbo].[EaGroupHeadline_Del_InHouse] ADD [RepUpdateTime] DATETIME2(7) CONSTRAINT [DF_EaGroupHeadline_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME())

	CREATE CLUSTERED INDEX [CIX_EaGroupHeadline_Del_InHouse_RepUpdateTime] ON [dbo].[EaGroupHeadline_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table EaGroupHeadline_Del_InHouse exists!!!'
END
GO
/***************************************************************************/

--index repupdatetime for dbcust.custdb

alter table EaGroupHeadline add [RepUpdateTime] [DATETIME2]
create nonclustered index IX_EaGroupHeadline_RepUpdateTime on EaGroupHeadline([RepUpdateTime]) on [DATA]
