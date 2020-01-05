/*
	Created: 20200105@Helen
	Task: update winlost and comm for master
	DB: DBTXN/bodb02
*/

USE bodb02
GO
-- update PT
DECLARE @m_PT SMALLMONEY

UPDATE b
	SET 
		@m_PT = b1.m2_correct
		, mpositiontaking = @m_PT
		, tpositiontaking = b.apositiontaking + @m_PT + b.spositiontaking
FROM bettrans b WITH (ROWLOCK)
	INNER JOIN Viet_C8_CorrectPT_20200105 b1 ON b.transid = b1.transid

GO	

