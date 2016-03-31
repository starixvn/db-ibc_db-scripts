/*
	Created by: Elodie
	Date: 20160321
	Task: Insert LogAction for Stake level and win loss limit update
	DB: DBLOG / bodb_CustomerLog
*/

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (850,'Acc_CustSetting_WinLossLimitUpd'
		,'Update Other Products Member Win/Loss Limit for customers'
		,'Update Other Products Member Win/Loss Limit for customers'
		,'Update Other Products Member Win/Loss Limit for customers'
		,'Update Other Products Member Win/Loss Limit for customers'
		,'Update Other Products Member Win/Loss Limit for customers'
		,'Update Other Products Member Win/Loss Limit for customers'
		,0
		,'Update Other Products Member Win/Loss Limit for customers'
		)

GO
INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES (391,'Acc_CustSetting_StakeLevelUpd'
		,'Update Other Products betting limit for customers'
		,'Update Other Products betting limit for customers'
		,'Update Other Products betting limit for customers'
		,'Update Other Products betting limit for customers'
		,'Update Other Products betting limit for customers'
		,'Update Other Products betting limit for customers'
		,0
		,'Update Other Products betting limit for customers'
		)

GO
SELECT * FROM dbo.LogAction WHERE ActionID IN(850,391)