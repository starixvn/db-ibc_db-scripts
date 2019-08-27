use bodb_Licensee
go

/*
	Created: 20190827@Percy
	DB: DB052.bodb_Licensee
	Task: 103658 - Clean DEL_, LIC_ tables
*/

declare @sql nvarchar(max) = ''

-- 71 tables
select @sql = @sql + 'drop table ' + name + char(13)
from sys.tables
where
	name like 'LIC[_]%' -- 47 tables (migrate)
	or name like 'DEL[_]%' -- 24 tables (drop)
order by name

--select @sql
exec(@sql)
go