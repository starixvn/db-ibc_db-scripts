/*
	Created: Winnie 
	Task: Update setting status
	DB: DBCUST/CustDB
	Date: 20170118
*/ 
DECLARE @Sporttype INT
SELECT @Sporttype = 219
UPDATE ProductSettingDetail (UPDLOCK,ROWLOCK)
SET SettingStatus=0
WHERE SportType=@Sporttype