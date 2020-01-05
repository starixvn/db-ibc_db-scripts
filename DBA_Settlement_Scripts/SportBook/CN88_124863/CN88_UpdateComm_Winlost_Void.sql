/*
	Created: 20200105@Helen
	Task: update winlost and comm for master
	DB: DBTXN/bodb02
*/
USE bodb02
GO
UPDATE b
	SET mWinLost = 0 , acomm = 0, scomm = 0
FROM bettrans b with (rowlock)
	INNER JOIN Viet_C8_CorrectPT_20200105 b1 with (nolock) on b.transid = b1.transid
WHERE b.statusid = 102