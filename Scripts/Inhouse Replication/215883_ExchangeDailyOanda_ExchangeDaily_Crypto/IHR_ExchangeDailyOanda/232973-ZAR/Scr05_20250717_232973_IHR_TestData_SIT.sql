/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20250717@Kelvin
	DB: DBCUST-CustDB
	Task : LAP - Support based ZAR (RedmineID: #232973)
*/
USE CUSTDB
GO

SELECT TOP 1 ZAR, *
FROM dbo.ExchangeDailyOanda WITH (NOLOCK)
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41

UPDATE ExchangeDailyOanda WITH (ROWLOCK, UPDLOCK)
SET	 ZAR=1
	,RepUpdateTime=dbo.f_GetDateTime2()
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41

waitfor delay '00:00:02.000'

SELECT TOP 1 ZAR, *
FROM dbo.ExchangeDailyOanda WITH (NOLOCK)
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41

--Select on DBACC
SELECT TOP 1 ZAR, *
FROM DBACC.bodb02.dbo.ExchangeDailyOanda WITH (NOLOCK)
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41

--return old data:
UPDATE ExchangeDailyOanda WITH (ROWLOCK, UPDLOCK)
SET	 ZAR=NULL
	,RepUpdateTime=dbo.f_GetDateTime2()
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41