/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
/*
	Created: 20220706@Danny
	DB: DBODDSFEED-bodb_OddsFeed
	Task: Support result for Cricket
*/
USE bodb_OddsFeed
GO

ALTER TABLE [dbo].[OddsSystemProfile] ADD  	[ResultDelayTimes] [varchar](100) NULL,
											[ResultDelayTimesFlag] [bit] NULL

ALTER TABLE [dbo].[OddsSystemProfile] ADD  CONSTRAINT [DF_OddsSystemProfile_ResultDelayTimesFlag]  DEFAULT ((1)) FOR [ResultDelayTimesFlag]

GO

ALTER TABLE [dbo].[PartnerProfile] ADD [ResultDelayTimes] [varchar](100) NULL


GO
UPDATE [dbo].[OddsSystemProfile] WITH(ROWLOCK, UPDLOCK) SET ResultDelayTimes = '5'

UPDATE [dbo].[PartnerProfile] WITH(ROWLOCK, UPDLOCK)  SET ResultDelayTimes = '5'