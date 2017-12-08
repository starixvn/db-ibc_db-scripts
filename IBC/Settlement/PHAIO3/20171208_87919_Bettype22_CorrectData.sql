/*
	Created: 20170812@Helen
	Task: HOTFIX - NAP Settlement - Calculating bettype 22 makes ticket status NULL - https://nexdev.net/issues/87919
	DB: DBTXN/bodb02

*/
USE bodb02
GO

CREATE TABLE #Bettype_22 (transid BIGINT)
INSERT INTO #Bettype_22 (transid)
SELECT transid
FROM bettrans WITH (NOLOCK)
WHERE bettype = 22 AND statusID IS NULL

UPDATE	b
	SET ruben = 0
		,[STATUS] = 'running'
		,statusID = 0
		,winlost = 0
		,awinlost = 0
		,mwinlost = 0
		,swinlost = 0
		,playercomm = 0
		,comm = 0
		,acomm = 0
		,scomm = 0
		,modds = 1
FROM	dbo.bettrans b WITH (ROWLOCK, UPDLOCK)
	INNER JOIN #Bettype_22 tmp ON tmp.transid = b.transid

DROP TABLE #Bettype_22
