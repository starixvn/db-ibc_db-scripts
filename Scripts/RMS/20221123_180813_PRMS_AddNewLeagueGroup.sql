/*<info serverAlias="DBRMS-bodb_RMS"></info>*/
/*
	Created: 20221123@Danny
	DB : DBRMS-bodb_RMS
	Task: Insert new League Group [Redmine: #180710]
*/

USE bodb_RMS

INSERT INTO dbo.rmLeagueGroup (GroupId, GroupName, OrderId)
values (12, 'WORLD CUP', 68)