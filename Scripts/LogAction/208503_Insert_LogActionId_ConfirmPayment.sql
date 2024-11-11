/*<info serverAlias="DBLOG-bodb_CustomerLog" isFunction="0" isNested=""></info>*/
/*
	Created: Lewis
	Task: insert LogAction for Rebate & Retenton [RedmineId: #208503]
	DB: DBLOG-bodb_CustomerLog
	Date: 20241111
	
*/
USE [bodb_CustomerLog]
GO

IF NOT EXISTS(SELECT 1 FROM LogAction WITH(NOLOCK) WHERE ActionID IN (95121,95122))
BEGIN
	INSERT INTO LogAction(ActionID,ActionTypeID,SPName,ActionNameEN,IsInternal)
	VALUES 
	 (95121,4,'Acc_RewardPayment_Confirm','Confirm Payment',1)
	,(95122,4,'Acc_RewardPayment_Confirm_Rollback','Rollback Confirm Payment',1)
END