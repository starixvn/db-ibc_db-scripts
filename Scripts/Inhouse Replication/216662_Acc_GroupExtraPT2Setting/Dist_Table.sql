/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: 
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_GroupExtraPT2Setting')
BEGIN
	CREATE TABLE [dbo].[Acc_GroupExtraPT2Setting]
	(
		[SuperId] [INT] NOT NULL
		,[GroupId] [INT] NOT NULL
		,[GroupName] [VARCHAR](50) NOT NULL
		,[ProductId] [TINYINT] NOT NULL
		,[Sporttype] [SMALLINT] NOT NULL
		,[SubProduct] [VARCHAR](500) NOT NULL
		,[ExtraPT] [DECIMAL](9,8) NOT NULL
		,[FromDate] [DATETIME] NOT NULL
		,[ToDate] [DATETIME] NOT NULL
		,[ID] [INT] IDENTITY(1,1) NOT NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		,[isDeleted] [BIT] NULL
		,CONSTRAINT [PK_Acc_GroupExtraPT2Setting] PRIMARY KEY NONCLUSTERED (ID) ON [DATA]
	) ON [DATA]

	ALTER TABLE [dbo].[Acc_GroupExtraPT2Setting] ADD CONSTRAINT [DF_Acc_GroupExtraPT2Setting_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
	
	ALTER TABLE [dbo].[Acc_GroupExtraPT2Setting] ADD CONSTRAINT [DF_Acc_GroupExtraPT2Setting_RepUpdateTime]  DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]
	
	CREATE NONCLUSTERED INDEX [IX_Acc_GroupExtraPT2Setting_RepUpdateTime] ON [dbo].[Acc_GroupExtraPT2Setting] 
	(
	  [RepUpdateTime] ASC
	)ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_GroupExtraPT2Setting exists!!!'
END
GO
/***************************************************************************/




