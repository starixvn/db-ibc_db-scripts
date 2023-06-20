/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20230620@Evan
	Task: Deposit - Remove disabled products CB & GD [Redmine: #188096]
	DB: DBLIC.msdb
	Remark: Run on pair DB052-DB053 (Step 1)

*/
USE [msdb]

GO

EXEC sp_update_jobstep @job_name =N'bodb_LicenseeReport: Daily Summary Licensee Winloss', 
		@step_id=1 , -- Update statistics
		@command=N'UPDATE STATISTICS rptLicWinloss2
UPDATE STATISTICS rptCustomerTurnover
UPDATE STATISTICS rptWinlostbyLeague
UPDATE STATISTICS rptCustomerMatch
UPDATE STATISTICS rpt_BettingParlay
UPDATE STATISTICS rptLicWinlossGMT'

GO

-- Remove step gen data for rpt_BettingColossusBets
EXEC sp_delete_jobstep @job_name = 'bodb_LicenseeReport: Daily Summary Licensee Winloss'
     , @step_id = 8 -- Gen data for @ rpt_BettingColossusBets
GO

EXEC sp_delete_jobstep @job_name = 'bodb_LicenseeReport: Licensee Winloss - Check and Correct Data'
     , @step_id = 11 -- Check and Correct Data for @ rpt_BettingColossusBets

GO
