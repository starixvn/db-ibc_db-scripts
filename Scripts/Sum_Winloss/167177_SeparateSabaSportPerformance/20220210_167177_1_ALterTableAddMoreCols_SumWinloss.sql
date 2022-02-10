/*<info serverAlias="DBTXN-bodb02"></info>*/

/*
Create: 20220210@Danny
Task: Alter table sum_winloss_old_tmp  [Redmine: #167177]
DB: DBTXN.bodb02

*/


USE bodb02
GO
 
ALTER TABLE [dbo].[sum_winloss_tmp]
ADD  leagueGroupID	SMALLINT CONSTRAINT [DF_sum_winloss_tmp_leagueGroupID] NOT NULL  DEFAULT ((0)),
	 ticketType		TINYINT	 CONSTRAINT [DF_sum_winloss_tmp_ticketType] NOT NULL DEFAULT ((0))
	
GO

ALTER TABLE [dbo].[sum_winloss]
ADD  leagueGroupID	SMALLINT CONSTRAINT [DF_sum_winloss_leagueGroupID] NOT NULL DEFAULT ((0)),
	 ticketType		TINYINT	 CONSTRAINT [DF_sum_winloss_ticketType]  NOT NULL DEFAULT ((0))

