/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20250324@Tacy
	DB: DBCUST-CustDB
	Task : SIT - Test sync data
*/
USE CUSTDB
GO

SELECT TOP 1 PKR, *
FROM dbo.ExchangeDailyOanda WITH (NOLOCK)
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41

UPDATE ExchangeDailyOanda WITH (ROWLOCK, UPDLOCK)
SET	 PKR=1
	,RepUpdateTime=dbo.f_GetDateTime2()
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41

--Select on DBACC
SELECT TOP 1 PKR, *
FROM DBACC.bodb02.dbo.ExchangeDailyOanda WITH (NOLOCK)
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41

--return old data:
UPDATE ExchangeDailyOanda WITH (ROWLOCK, UPDLOCK)
SET	 PKR=NULL
	,RepUpdateTime=dbo.f_GetDateTime2()
WHERE ExchangeDate='2025-02-28 00:00:00.000' and ExchangeId=41