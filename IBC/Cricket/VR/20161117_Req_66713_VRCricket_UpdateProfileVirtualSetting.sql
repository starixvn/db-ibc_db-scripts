/*
	Created: Winnie
	Date: 2016-11-17
	Task: Update isactive=1 on ProfileVirtualSetting for Cricket RedmineID:#66713
	DB: DBCUST/CustDB
*/ 

UPDATE [ProfileVirtualSetting]
SET isActive=1
WHERE sporttype=27 and bettype=5

GO

