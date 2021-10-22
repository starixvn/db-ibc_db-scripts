/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20210927@Percy
	DBRPT-bodb_Report
	Task: Gen data for apositiontaking column (rptLicWinloss2)
	Step 4: Insert data into temp table (rptLicWinloss2)
*/
use bodb_Report
go

declare @winlostdate smalldatetime = '2021-08-01'
while @winlostdate <= '2021-09-10'
begin
	exec dbo.Task_DailyRptLicWinloss2_temp @winlostdate = @winlostdate

	select @winlostdate = dateadd(day, 1, @winlostdate)

	waitfor delay '00:00:00.280'
end