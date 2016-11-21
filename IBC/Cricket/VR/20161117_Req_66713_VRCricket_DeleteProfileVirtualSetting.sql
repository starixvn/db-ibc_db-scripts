/*
	Created: Winnie
	Date: 2016-11-17
	Task: Insert ProfileVirtualSetting for UAT Cricket RedmineID:#66713
	DB: DBCUST/CustDB
*/ 

DELETE FROM [ProfileVirtualSetting]
WHERE sporttype=27 AND bettype=5
GO