/*<info serverAlias="DBSIG-bodb02" isFunction="0" isNested=""></info>*/
/*
	Created: 20221006@Danny
	DB: DBTXN.bodb02
	Task: update CurrencyName of transfer ticket - [Redmind: #178818]

*/

USE bodb02

CREATE TABLE #temp (refno BIGINT, transid BIGINT, CurrencyName NVARCHAR(10))

INSERT INTO #temp(refno, transid, CurrencyName)
select refno, transid, e.currency  from transfer t with (nolock)
INNER JOIN CustDB.dbo.Exchange e with (NOLOCK) on t.currency = e.exchangeid 
where t.WinlostDate = '2022-10-05' AND t.bettype = 21003 AND CAST(t.CurrencyName AS NVARCHAR(10)) = CAST(  t.Currency  AS NVARCHAR(10))  

-- 12 tickets
UPDATE t
SET t.CurrencyName = tp.CurrencyName,
	t.RepUpdateTime = SYSDATETIME()
FROM dbo.transfer t WITH(ROWLOCK, UPDLOCK)
INNER JOIN #temp tp ON t.transid = tp.transid

DROP TABLE #temp
