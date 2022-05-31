/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
Create: 20220210@Danny
Task: Alter table sum_winloss_old  [Redmine: #167177]
DB: DBARC-bodb_Archive

*/

USE bodb_Archive
GO
 
ALTER TABLE [dbo].[sum_winloss_old_tmp]
ADD  leagueGroupID	SMALLINT,
	 ticketType		TINYINT
	

ALTER TABLE  [dbo].[sum_winloss_old_tmp] ADD  CONSTRAINT [DF_sum_winloss_old_tmp_leagueGroupID] DEFAULT ((0)) FOR leagueGroupID;
ALTER TABLE  [dbo].[sum_winloss_old_tmp] ADD  CONSTRAINT [DF_sum_winloss_old_tmp_ticketType] DEFAULT ((0)) FOR ticketType;