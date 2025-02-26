/*<info serverAlias="IRS_DBTP-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250115@Lewis	
	Task: In-House
	DB: 
	
	Revisions:
		- 20250115@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'EaGroupHeadline')
BEGIN
	CREATE TABLE [dbo].[EaGroupHeadline]
	(
		[GroupHeadlineId] [INT] NOT NULL
		,[GroupId] [INT] NOT NULL
		,[GroupName] [VARCHAR](100) NOT NULL
		,[SiteId] [INT] NOT NULL
		,[ExchangeId] [INT] NOT NULL
		,[GroupTypeId] [TINYINT] NULL
		,[EffectiveDate] [DATETIME] NULL
		,[EndDate] [DATETIME] NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		,[isDeleted] [BIT] NULL
		,CONSTRAINT [PK_EaGroupHeadline] PRIMARY KEY CLUSTERED ([GroupHeadlineId],[GroupId],[GroupName],[SiteId],[ExchangeId]) ON [DATA]
	) ON [DATA]

	ALTER TABLE [dbo].[EaGroupHeadline] ADD CONSTRAINT [DF_EaGroupHeadline_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
	
	ALTER TABLE [dbo].[EaGroupHeadline] ADD CONSTRAINT [DF_EaGroupHeadline_RepUpdateTime]  DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]
	
	CREATE NONCLUSTERED INDEX [IX_EaGroupHeadline_RepUpdateTime] ON [dbo].[EaGroupHeadline] 
	(
	  [RepUpdateTime] ASC
	)ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table EaGroupHeadline exists!!!'
END
GO
/***************************************************************************/




