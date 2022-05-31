/*<info serverAlias="DBTXN-bodb02"></info>*/

/*
Create: 20220210@Danny
Task: Alter table sum_winloss_old_tmp  [Redmine: #167177]
DB: DBTXN.bodb02

*/


USE bodb02
GO
 
ALTER TABLE [dbo].[sum_winloss_tmp]
ADD  leagueGroupID	SMALLINT,
	 ticketType		TINYINT
	
ALTER TABLE [dbo].[sum_winloss_tmp] ADD  CONSTRAINT [DF_sum_winloss_tmp_leagueGroupID] DEFAULT ((0)) FOR leagueGroupID;
ALTER TABLE [dbo].[sum_winloss_tmp] ADD  CONSTRAINT  [DF_sum_winloss_tmp_ticketType] DEFAULT ((0)) FOR ticketType;
GO

ALTER TABLE [dbo].[sum_winloss]
ADD  leagueGroupID	SMALLINT,
	 ticketType		TINYINT

ALTER TABLE [dbo].[sum_winloss] ADD  CONSTRAINT [DF_sum_winloss_leagueGroupID] DEFAULT ((0)) FOR leagueGroupID;
ALTER TABLE [dbo].[sum_winloss] ADD  CONSTRAINT [DF_sum_winloss_ticketType] DEFAULT ((0)) FOR ticketType;
