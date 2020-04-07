USE bodb_CustomerLog
GO

/*
	Created: 20200407@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: Update translation for Enabled/Disabled All day balance transfer

	SELECT IsInternal, *
	FROM bodb_CustomerLog.dbo.LogAction WITH (NOLOCK)
	WHERE ActionID IN (705, 706)
*/

UPDATE dbo.LogAction WITH (ROWLOCK)
SET ActionNameCH = N'啟用/禁用全天余額轉賬。',
	ActionNameCS = N'启用/禁用全天余额转账。',
	ActionNameTH = N'เปิด / ปิด การโอนยอดคงเหลือตลอดทั้งวัน'
WHERE ActionID IN (705, 706) -- Enabled/Disabled All day balance transfer
GO