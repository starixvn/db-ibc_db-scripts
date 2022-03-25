/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
Create: 20220210@Danny
Task: Alter table sum_winloss_old  [Redmine: #167177]
DB: DBSUM-bodb_Summary

*/


USE bodb_Summary
GO
 
ALTER TABLE [dbo].[sum_winloss_old]
ADD  leagueGroupID	SMALLINT,
	 ticketType		TINYINT
	

	
ALTER TABLE  [dbo].[sum_winloss_old] ADD  CONSTRAINT [DF_sum_winloss_old_leagueGroupID] DEFAULT ((0)) FOR leagueGroupID;
ALTER TABLE  [dbo].[sum_winloss_old] ADD  CONSTRAINT [DF_sum_winloss_old_ticketType] DEFAULT ((0)) FOR ticketType;