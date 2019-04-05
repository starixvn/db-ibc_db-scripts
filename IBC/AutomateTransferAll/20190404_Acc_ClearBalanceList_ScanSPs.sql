/*
	Created: 20190404@Percy
	DB: all servers, all databases
	Task: Scan all objects to using Acc_ClearBalanceList (DBCUST.CustDB) table [RedmineID: #110054]
*/

SELECT DISTINCT
       o.name AS Object_Name,
       o.type_desc
FROM sys.sql_modules m
    INNER JOIN sys.objects o ON m.object_id = o.object_id
WHERE m.definition Like '%Acc_ClearBalanceList%'
	and o.name NOT LIKE '%_xtest'
	and o.name NOT LIKE '%_xpre'
	and o.name NOT LIKE '%_UAT1'
	and o.name NOT LIKE '%_UAT2'
	and o.name NOT LIKE '%_UAT3'
	and o.name NOT LIKE '%_UAT4'