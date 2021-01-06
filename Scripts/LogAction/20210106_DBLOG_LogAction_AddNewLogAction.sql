/*<info serverAlias="DBLOG-bodb_CustomerLog"></info>*/

/*
	Created by: Malcolm
	Date: 2021-01-06
	Task: Insert LogAction into table  [#redmindId: 147430]
	DB: DBLOG/bodb_CustomerLog
*/

INSERT INTO dbo.LogAction (ActionID, ActionTypeID, SPName, ActionNameEN, IsInternal)
VALUES (95038, 4, 'EAS_Bonus_Ins','Headline create bonus', 1)
, (95039, 4, 'Age_ConfirmPayment','Update Payement Date', 1)
, (95040, 4, 'EAS_CancelBonus','Cancel Bonus', 1)


