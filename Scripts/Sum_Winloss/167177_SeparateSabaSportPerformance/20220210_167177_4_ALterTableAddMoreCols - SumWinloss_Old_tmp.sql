/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
Create: 20220210@Danny
Task: Alter table sum_winloss_old  [Redmine: #167177]
DB: DBARC-bodb_Archive

*/

USE bodb_Archive
GO
 
ALTER TABLE [dbo].[sum_winloss_old_tmp]
ADD  leagueGroupID	SMALLINT CONSTRAINT [DF_sum_winloss_old_tmp_leagueGroupID] NOT NULL DEFAULT ((0)),
	 ticketType		TINYINT	 CONSTRAINT [DF_sum_winloss_old_tmp_ticketType] NOT NULL DEFAULT ((0))
	
