/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20211104@Percy
	DB: DBRPT-bodb_Report
	Task: Manually correct recommend
*/
USE bodb_Report
GO

-- Statement
/*
	select top 10* from dbo.Statement with (nolock)
	where custid in (56713984,56713996 , 56948071,56948082 )and accdate > = '20211027'

	select recommend,winlostdate accdate, sum(awinlost) totalamt,'POS' transtype, 'Position' transdesc
	from bodb02.dbo.bettrans14 with (nolock)
	where bettype between 1 and 19999 and winlostdate BETWEEN '2021-10-27' AND '2021-10-28'
		and recommend in (56713984, 56713996, 56948071, 56948082)
	group by winlostdate, recommend
	HAVING sum(awinlost) <> 0
*/

UPDATE dbo.Statement WITH (ROWLOCK)
SET custid = 56713996
WHERE custid = 56713984 
	AND accdate > = '20211027'