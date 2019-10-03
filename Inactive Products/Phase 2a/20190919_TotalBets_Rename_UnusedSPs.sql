use bodb02
go

/*
	Created: 20190919@Percy
	DB: DB052.bodb02, DB053.bodb02, DB06.bodb02, DB061.bodb02
	Task: Clean up SPs of Alpha - Total Bets
	RedmineID: #118699

	Remark: exec result
*/

declare @sql varchar(max) = ''

select @sql = @sql + 'sp_rename ''' + o.name + ''',''' + 'DEL_' + o.name + '''' + char(10) + 'go' + char(10)
from sys.objects o with (nolock)
where type = 'p'
	and name like 'Age_TotalBets_%'
order by name

print @sql