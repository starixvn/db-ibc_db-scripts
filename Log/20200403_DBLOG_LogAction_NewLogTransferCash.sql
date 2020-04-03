USE bodb_CustomerLog
GO

/*
	Created: 20200403@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: Transfer Cash Enhancement - New log action in case "All Day Balane Transfer" for Master is updated by following Super
	RedmineID: #130741
*/

DECLARE @ActionID INT = 65019,
		@ActionTypeID INT = 5,
		@SPName VARCHAR (50) = 'Acc_CustomerUpdAllDayBalTransfer',
		@ActionNameEN NVARCHAR(256) = N'Enabled/Disabled All day balance transfer on Super',
		@ActionNameCH NVARCHAR(256) = N'啟用/禁用全天余額轉賬於超級總代理。',
		@ActionNameCS NVARCHAR(256) = N'启用/禁用全天余额转账于超级总代理。',
		@ActionNameTH NVARCHAR(256) = N'เปิด / ปิด ยอดโอนตลอดทั้งวันไปยังซุปเปอร์'

INSERT INTO dbo.LogAction (ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI,ActionNameCN)
VALUES (@ActionID,@ActionTypeID,@SPName,@ActionNameEN,@ActionNameCH,@ActionNameCS,@ActionNameEN,@ActionNameEN,@ActionNameTH,@ActionNameEN,1,@ActionNameEN,@ActionNameEN)
GO