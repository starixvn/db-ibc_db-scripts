/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Created: 20210205@Percy
	DB: DBACC-bodb02
	Task: Regen data for AG Casino
*/
use bodb02
go

exec dbo.Task_DOT_AGCasino_DailySummary
	@winlostdate = '2021-01-14'
	,@IsManual = 1
	,@GenForDataWarehouse = 0