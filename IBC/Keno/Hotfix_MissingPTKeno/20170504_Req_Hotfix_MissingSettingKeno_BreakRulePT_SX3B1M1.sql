/*
	Created: 20170504@Helen
	Task: Keno - FIX break rule PT - [Redmine: 76020]

*/

UPDATE CS
	SET apositiontaking = 0.7
FROM CustSettingGame CS WITH (ROWLOCK,UPDLOCK)
WHERE CS.CustID = 24847675 AND Sporttype = 202 AND Bettype IN (1503,1504)

