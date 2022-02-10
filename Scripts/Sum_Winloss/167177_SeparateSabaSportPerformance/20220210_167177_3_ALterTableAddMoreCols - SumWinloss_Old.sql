/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
Create: 20220210@Danny
Task: Alter table sum_winloss_old  [Redmine: #167177]
DB: DBSUM-bodb_Summary

*/


USE bodb_Summary
GO
 
ALTER TABLE [dbo].[sum_winloss_old]
ADD  leagueGroupID	SMALLINT CONSTRAINT [DF_sum_winloss_old_leagueGroupID] NOT NULL DEFAULT ((0)),
	 ticketType		TINYINT	 CONSTRAINT [DF_sum_winloss_old_ticketType] NOT NULL DEFAULT ((0))
	
