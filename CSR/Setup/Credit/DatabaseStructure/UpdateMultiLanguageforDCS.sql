/*
	Description: Script update LogAction and MsgError to support multi-languages for DCS
	Creator: 20151123@Billy
    DB: DBLOG.bodb_CustomerLog
*/

USE [bodb_CustomerLog]
GO

-- BEGIN STEP 1: Update multi-languages LogAction	--
------------------------------------------------------

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Other Products Commission for customers',
	[ActionNameCH] = N'更新其他傭金以客戶',
    [ActionNameCS] = N'更新其他佣金以客戶',
	[ActionNameTH] = N'อัพเดทค่าคอมมิชชั่นในผลิตภันฑ์อื่นๆ ให้ลูกค้า'
WHERE ActionID = 237

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Other Products Bet Setting for customers',
	[ActionNameCH] = N'更新其他投註設定以客戶',
    [ActionNameCS] = N'更新其他投注设定以客户',
	[ActionNameTH] = N'อัพเดทค่าการเดิมพันในผลิตภันฑ์อื่นๆ ให้ลูกค้า'
WHERE ActionID = 384

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Other Product Position Taking for Super',
	[ActionNameCH] = N'更新其他的占成數以超級總代理',
    [ActionNameCS] = N'更新其他的占成数以超级总代理',
	[ActionNameTH] = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ให้ ซูเปอร์'
WHERE ActionID = 448

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Other Product Position Taking for Master',
	[ActionNameCH] = N'更新其他的占成數以總代理',
    [ActionNameCS] = N'更新其他的占成数以总代理',
	[ActionNameTH] = N'อัพเดทค่าคอมมิชชั่นในผลิตภันฑ์อื่นๆ ให้มาสเตอร์'
WHERE ActionID = 449

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Other Products Position Taking for member (Multiple)',
	[ActionNameCH] = N'更新其他的占成數以會員（多重）',
    [ActionNameCS] = N'更新其他的占成数以会员（多重）',
	[ActionNameTH] = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ให้เมมเบอร์ (หลายบัญชี)'
WHERE ActionID = 450

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Master''s Other Products Position Taking for member (Multiple)',
	[ActionNameCH] = N'更新總代理其他的占成數以會員（多重）',
    [ActionNameCS] = N'更新总代理其他的占成数以会员（多重）',
	[ActionNameTH] = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ของมาสเตอร์ให้เมมเบอร์ (หลายบัญชี)'
WHERE ActionID = 451

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Super''s Other Products Position Taking for member (Multiple)',
	[ActionNameCH] = N'更新超級總代理其他的占成數以會員（多重）',
    [ActionNameCS] = N'更新超级总代理其他的占成数以会员（多重）',
	[ActionNameTH] = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ของซูเปอร์ให้เมมเบอร์  (หลายบัญชี)'
WHERE ActionID = 452

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Other Products Position Taking for member',
	[ActionNameCH] = N'更新其他的占成數以會員',
    [ActionNameCS] = N'更新其他的占成数以会员',
	[ActionNameTH] = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ให้เมมเบอร์'
WHERE ActionID = 453

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Other Product Position Taking for Agent',
	[ActionNameCH] = N'更新其他的占成數以代理',
    [ActionNameCS] = N'更新其他的占成数以代理',
	[ActionNameTH] = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ให้ เอเจนท์'
WHERE ActionID = 454

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Super''s Other Product Position Taking for member',
	[ActionNameCH] = N'更新超級總代理的其他占成數以會員',
    [ActionNameCS] = N'更新超级总代理的其他占成数以会员',
	[ActionNameTH] = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ของซูเปอร์ให้เมมเบอร์'
WHERE ActionID = 455

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update Master''s Other Product Position Taking for member',
	[ActionNameCH] = N'更新總代理其他的占成數以會員',
    [ActionNameCS] = N'更新总代理其他的占成数以会员',
	[ActionNameTH] = N'อัพเดทค่าความเสี่ยงในผลิตภันฑ์อื่นๆ ของมาสเตอร์ให้เมมเบอร์'
WHERE ActionID = 456

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update enabled/disabled Other Products status',
	[ActionNameCH] = N'更新其他產品開啟/禁用狀態',
    [ActionNameCS] = N'更新其他产品开启/禁用状态',
	[ActionNameTH] = N'อัพเดทสถานะ เปิดใช้งาน/ ปิดการใช้งาน ในผลิตภันฑ์อื่นๆ'
WHERE ActionID = 1152

UPDATE [dbo].[LogAction] WITH(ROWLOCK,UPDLOCK)
SET [ActionNameEN] = N'Update initial Other Products status',
	[ActionNameCH] = N'更新最初其他狀態',
    [ActionNameCS] = N'更新最初其他状态',
	[ActionNameTH] = N'อัพเดทสถานะเริ่มต้นของผลิตภันฑ์อื่นๆ'
WHERE ActionID = 1153

GO


-- BEGIN STEP 2: Update multi-languages MsgError	--
------------------------------------------------------

UPDATE [dbo].[MsgError] WITH(ROWLOCK,UPDLOCK)
SET [MsgNameEN] = N'Account disabled for this product. Unable to edit downlines.',
	[MsgNameCT] = N'賬戶已禁用此產品，無法修改下線',
	[MsgNameCS] = N'账户已禁用此产品，无法修改下线',
	[MsgNameTH] = N'บัญชีถูกปิดการใช้งานผลิตภันฑ์นี้ ไม่สามารถแก้ไขการตั้งค่าให้ดาวน์ไลน์ได้'
WHERE MsgID = 60033

UPDATE [dbo].[MsgError] WITH(ROWLOCK,UPDLOCK)
SET [MsgNameEN] = N'Cannot synchronize this product because this account''s upline not synchronize setting.',
	[MsgNameCT] = N'上線還沒連接此帳戶設定，因此無法連接此產品。',
	[MsgNameCS] = N'上线还没连接此帐户设定，因此无法连接此产品。',
	[MsgNameTH] = N'ไม่สามารถเชื่อมต่อ(Synchronize) ผลิตภันฑ์นี้เนื่องจากบัญชีต้นสายไม่เชื่อมต่อ(Synchronize) การตั้งค่า'
WHERE MsgID = 60034

GO

