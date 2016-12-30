/*
	Created: 20161230@Elodie
	Task: Fix comission of AllBet on member level
	DB: DBCUST/CustDB
*/

-- 8826 affected rows
UPDATE cs
SET cs.SuperDiscount = css.Discount,
	cs.MasterDiscount = csm.Discount,
	cs.AgentDiscount = csa.Discount
FROM dbo.CustDiscount3rd_Member cs WITH (ROWLOCK, UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH (NOLOCK) ON ci.custid = cs.CustID 
	INNER JOIN dbo.CustDiscount3rd_Agent css WITH (NOLOCK) ON ci.srecommend = css.CustID AND cs.SportType = css.SportType AND cs.BetType = css.BetType
	INNER JOIN dbo.CustDiscount3rd_Agent csm WITH (NOLOCK) ON ci.mrecommend = csm.CustID AND cs.SportType = csm.SportType AND cs.BetType = csm.BetType
	INNER JOIN dbo.CustDiscount3rd_Agent csa WITH (NOLOCK) ON ci.recommend = csa.CustID AND cs.SportType = csa.SportType AND cs.BetType = csa.BetType
WHERE cs.SportType = 211 AND cs.BetType = 2401
	AND (cs.SuperDiscount <> css.Discount OR cs.MasterDiscount <> csm.Discount OR cs.AgentDiscount <> csa.Discount)
	AND ci.Enabled = 1
	