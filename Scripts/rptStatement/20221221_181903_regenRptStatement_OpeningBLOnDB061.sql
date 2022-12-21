/*<info serverAlias="DB061-bodb_report"></info>*/

use bodb_report

/*
	Created: 20221221@Sophia
	DB: DBPRT-bodb_report
	Task: Re-gen rptStatement ON DB061 [RedmineID: #181903]
*/


EXEC [dbo].[Task_DailyRptStatement_CheckData] @winlostdate = '20221216', @isCheckDataOnly = 0

EXEC [dbo].[Task_DailyRptStatement_CheckData] @winlostdate = '20221217', @isCheckDataOnly = 0
			