/*<info serverAlias="DBLOG-bodb_CustomerLog"></info>*/

/*
	Created by: Malcolm
	Date: 2021-01-06
	Task: Insert LogAction into table  [#redmindId: 147430]
	DB: DBLOG/bodb_CustomerLog
*/

INSERT INTO dbo.LogAction (ActionID, ActionTypeID, SPName, ActionNameEN, IsInternal)
VALUES (20401, 4, 'EAS_Bonus_Ins','Create Bonus', 1)
,(20402, 4, 'EAS_Bonus_Cancel','Cancel Bonus', 1)
,(708, 5, 'Age_Bonus_ConfirmPayment','Update Payement Date', 0)







