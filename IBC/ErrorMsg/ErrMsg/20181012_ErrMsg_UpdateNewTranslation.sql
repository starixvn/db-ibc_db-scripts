USE [CustDB]
GO

/*
	Created: 20181012@Percy
	DB: DBCUST.CustDB
	Task: Update translation error messages

	SELECT *
	FROM dbo.MsgError WITH (NOLOCK)
	WHERE MsgId IN (40036, 40037, 50012, 50013, 50014)
*/

-- Remove messages
DELETE dbo.MsgError WITH (ROWLOCK, UPDLOCK)
WHERE MsgId IN (40036, 40037, 50012, 50013, 50014)

CREATE TABLE #MsgError
(
	MsgID		INT,
	MsgGroupID	INT,
	IsActive	BIT,
	MsgNameEN	NVARCHAR(500),
	MsgNameCT	NVARCHAR(500),
	MsgNameCS	NVARCHAR(500),
	MsgNameJP	NVARCHAR(500),
	MsgNameTH	NVARCHAR(500),
	MsgNameKO	NVARCHAR(500),
	MsgNameES	NVARCHAR(500),
	MsgNameVI	NVARCHAR(500),
	MsgNameCN	NVARCHAR(500)
)

INSERT INTO #MsgError
(
	MsgID,
	MsgGroupID,
	IsActive,
	MsgNameEN,
	MsgNameCT,
	MsgNameCS,
	MsgNameTH,
	MsgNameVI
)
SELECT 40036, 5, 1, 'The selected customer has no credit to be cleared.', N'所選客戶無信用額度可清除', N'所选客户无信用额度可清除', N'ลูกค้าที่เลือกไม่มีเครดิตจะถูกหักล้าง', N'Tài khoản được chọn hiện không có tín dụng để xóa.' UNION ALL
SELECT 40037, 5, 1, 'There are downline(s) with negative given credit.', N'下線有負數的信用額度。', N'下线有负数的信用额度。', N'ดาวน์ไลน์ (s) มีเครดิตเป็นค่าติดลบ', N'Cấp dưới bị âm hạn mức được cấp.' UNION ALL
SELECT 50012, 6, 1, 'Transfer all will create negative bet credit on member(s). Please use the Transfer function to transfer for those members before transfer all by this function.', N'全數轉賬會導致會員的投註額變成負數。因此，在使用全數轉賬功能前，請用轉賬功能和這些會員轉賬。', N'全数转账会导致会员的投注额变成负数。因此，在使用全数转账功能前，请用转账功能和这些会员转账。', N'การล้างยอดจะส่งผลให้เครดิตเดิมพันของสมาชิก (s) ติดลบ. กรุณาใช้ฟังก์ชัน โอนยอด เพื่อโอนล้างยอดให้กับสมาชิกเหล่านั้นก่อน จึงจะใช้ โอนยอดทั้งหมด ได้', N'Việc tất toán sẽ làm cho hạn mức khả dụng của Member bị âm. Vui lòng dùng chức năng Chuyển Khoản để chuyển khoản cho những Member đó trước khi Tất Toán.' UNION ALL
SELECT 50013, 6, 1, 'There are member(s) who have been transferred today. Please try again tomorrow.', N'有會員在今天已經被轉賬。請明天再嘗試。', N'有会员在今天已经被转账。请明天再尝试。', N'มีสมาชิกที่ได้โอนล้างยอดแล้วในวันนี้ กรุณาลองใหม่อีกครั้งในวันพรุ่งนี้', N'Có Member đã được chuyển khoản hôm nay. Vui lòng thử lại vào ngày mai.' UNION ALL
SELECT 50014, 6, 1, 'You can only transfer on: ', N' 可行轉帳日為: ', N'可行转帐日为: ', N'คุณสามารถโอนได้เฉพาะ: ', N'Bạn chỉ được chuyển khoản vào: '

UPDATE #MsgError
SET MsgNameJP = MsgNameEN,
	MsgNameKO = MsgNameEN,
	MsgNameES = MsgNameEN,
	MsgNameCN = MsgNameEN

INSERT INTO dbo.MsgError(MsgID,MsgGroupID,IsActive,MsgNameEN,MsgNameCT,MsgNameCS,MsgNameJP,MsgNameTH,MsgNameKO,MsgNameES,MsgNameVI,MsgNameCN)
SELECT MsgID,MsgGroupID,IsActive,MsgNameEN,MsgNameCT,MsgNameCS,MsgNameJP,MsgNameTH,MsgNameKO,MsgNameES,MsgNameVI,MsgNameCN
FROM #MsgError

DROP TABLE #MsgError