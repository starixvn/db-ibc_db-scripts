/*
	Created: Vicky
	Task: insert task for Happy5
	DB: DBTXN/bodb02
	Date: 20181019
*/
USE [bodb_Consistency]
GO



------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBA_Rules (RuleId, Name, Description, SeverityLevel)
VALUES
	 --betteam
	 (15,'Check betteam value','ISNULL(betteam, '''') <> ''''','High')
	 
	 --stake
	,(16,'Check if no discount, no comm'
	  ,'ISNULL(playerdiscount, 0) = ISNULL(discount, 0) = ISNULL(adiscount, 0) = ISNULL(sdiscount, 0) = 0; ISNULL(playercomm, 0) = ISNULL(comm, 0) = ISNULL(acomm, 0) = ISNULL(scomm, 0) = 0'
	  ,'High')
	
