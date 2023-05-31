/*<info serverAlias="DBAGE-bodb_AGE"></info>*/
USE bodb_AGE

/*
	Created: 20230530@Evan
	DB: DBAGE-bodb_AGE
	Task: Drop un-used SP [Redmine: #173554]
*/
GO

EXEC sp_rename 'Age_Rpt_GetTimeRange', 'DEL_Age_Rpt_GetTimeRange'
