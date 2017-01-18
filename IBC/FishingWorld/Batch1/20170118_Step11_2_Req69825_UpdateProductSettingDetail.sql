/*
	Created: Winnie 
	Task: Update setting status
	DB: DBCUST/CustDB
	Date: 20170118
*/ 

UPDATE ProductSettingDetail (UPDLOCK,ROWLOCK)
SET SettingStatus=0
WHERE SportType=219