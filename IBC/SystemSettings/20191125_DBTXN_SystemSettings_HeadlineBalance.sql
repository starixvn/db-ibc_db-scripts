use bodb02
go

/*
	Created: 20191125@Percy
	DB: DBTXN.bodb02
	Task: Headline Balance Job - Initialize setting
*/

insert into dbo.SystemSettings (VName, VValue)
select 'isCalculatingHeadlineBalance', '0'
union all
select 'HeadlineBalanceDate', '2019-11-25'