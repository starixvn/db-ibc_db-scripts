/*<info serverAlias="DBTXN-bodb02, DBCUST-CustDB"></info>*/

/*
	Created by: Malcolm
	Date: 2021-01-12
	Task: Add message
	DB: DBTXN-bodb02,  DBCUST-CustDB
	
*/

INSERT INTO dbo.MsgError(MsgID, MsgGroupID, MsgNameEN, IsActive)
VALUES (50016, 6, 'Invalid payment date.', 1)
,(50017, 6, 'The selected Bonus is not Pending anymore, you cannot confirm its payment.',1)