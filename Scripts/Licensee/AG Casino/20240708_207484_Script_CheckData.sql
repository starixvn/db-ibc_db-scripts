/*
	Created: 20240704@Kelvin
	DB: DBLIC-bodb_LicenseeReport
	Task: AG Casino - Enhance job check data [RedmineID: #207484]		
*/

declare @HasDataMismatch tinyint = 0
		,@fromdate date = '2024-06-03'
		,@todate date = '2024-06-14'

while @fromdate <= @todate
begin
	set @HasDataMismatch = 0

	exec dbo.[Task_rptDepWinlost_AGCasino_CheckData] @WinlostDate = @fromdate, @HasDataMismatch = @HasDataMismatch out
	
	if @HasDataMismatch <> 0
	begin
		print(cast(@fromdate as varchar(20)) + ' : ' + cast(@HasDataMismatch as varchar(1)))
	end

	set @fromdate = dateadd(d,1,@fromdate)
end
