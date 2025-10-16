/*<info serverAlias="DBTP-bodb02"></info>*/
/*
	Created: 20251014@Kelvin
	DB: DBTP-bodb02
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

--DBKULC1
USE bodb02
GO
ALTER FUNCTION [dbo].[f_GetBetTradeCustList]
(
	@site varchar(10)
)

/*	Created: 20150625@Patrick
	Task: get bettrade cust list
	DB: DB052/bodb02, DB06/bodb02
	Revisions:
		- 20210816@Sophia: add DBBAL [Redmine: #154300]
		- 20251014@Kelvin: Upgrade ExchangeId Datatype [Redmine: #222339]
*/
RETURNS @returntable TABLE 
(
	CustId INT,
	Currency SMALLINT
)
AS
BEGIN
	INSERT INTO @returntable(CustId, Currency)
	SELECT c.CustId, c.currency
	FROM dbo.Dep_CustSuper s WITH(NOLOCK)
		INNER JOIN dbo.Customer c WITH(NOLOCK) ON s.CustId = c.srecommend
		INNER JOIN DBCUST.CustDB.dbo.BetTradeCust bt WITH(NOLOCK) ON c.CustId = bt.CustId
	WHERE c.RoleId = 1
		AND (@site = 'ALL' OR (@site <> 'ALL' AND s.site = @site))

	RETURN
END