--Affiliate_12BET DB Checksum - There is an error when summarize data to MemberDaily table.

--DB054
--Script to fix: 
 
--Exec Task_Aff_MemberDailySummary   @winlostdate = '2013-08-05'


/*
--check sum data (same sp with checksum service)

declare @IsMatch bit
Exec aff_checksum @IsMatch = @IsMatch output, @Date = '2012-08-08'
select @IsMatch
*/