/*
	Description: A script to update ActionName for ActionID: 450, 451, 452
	Creator: 20151228@Billy
	DB: DBLOG/bodb_CustomerLog
*/

USE [bodb_CustomerLog]
GO

UPDATE LogAction
SET	ActionNameEN = N'Update Other Products Position Taking for member',
	ActionNameCH = N'更新其他的占成數以會員',
	ActionNameCS = N'更新其他的占成数以会员',
	ActionNameTH = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ให้เมมเบอร์'
WHERE ActionID = 450

UPDATE LogAction
SET	ActionNameEN = N'Update Master''s Other Products Position Taking for member',
	ActionNameCH = N'更新總代理其他的占成數以會員',
	ActionNameCS = N'更新总代理其他的占成数以会员',
	ActionNameTH = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ของมาสเตอร์ให้เมมเบอร์'
WHERE ActionID = 451

UPDATE LogAction
SET	ActionNameEN = N'Update Super''s Other Products Position Taking for member',
	ActionNameCH = N'更新超級總代理的其他占成數以會員',
	ActionNameCS = N'更新超级总代理的其他占成数以会员',
	ActionNameTH = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ของซูเปอร์ให้เมมเบอร์'
WHERE ActionID = 452
GO
