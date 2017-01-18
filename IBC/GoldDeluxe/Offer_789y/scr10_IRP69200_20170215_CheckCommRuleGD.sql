/*
	Created: Johnson
	Date: 2017-02-15
	Task: check comm rule for 789y accounts
	DB: DB06/bodb02
*/

CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 
	AND site = '789y'
	AND currency <> 20
GO

CREATE TABLE ##CheckCommResult_Credit(
	[RuleId] [smallint] NULL,
	[SportType] [smallint] NULL,
	[BetType] [smallint] NULL,
	[CustIdA] [int] NULL,
	[CustIdB] [int] NULL,
	[ValueA] [smallmoney] NULL,
	[ValueB] [smallmoney] NULL	
) 

GO

SET NOCOUNT ON 

DECLARE @SportType SMALLINT = 255

SELECT cs.CustID,ci.recommend,ci.mrecommend,ci.srecommend, cs.SportType,cs.BetType,cs.sdiscount AS SuperDiscount, cs.adiscount AS MasterDiscount, cs.discount AS AgentDiscount, cs.PlayerDiscount
INTO #MemberComm
FROM dbo.CustInfo ci
	INNER JOIN dbo.custsettinggame cs WITH (NOLOCK) ON ci.CustID = cs.CustID
WHERE ci.srecommend IN (SELECT custid FROM #supers) 
		AND ci.roleid = 1  
		AND ci.Enabled = 1      		   
		AND cs.SportType = @SportType
	

SELECT cs.CustID,ci.recommend,ci.mrecommend,ci.srecommend, cs.SportType,cs.BetType,cs.Discount
INTO #AgentComm
FROM dbo.CustInfo ci
	INNER JOIN dbo.custsettinggame cs WITH (NOLOCK) ON ci.CustID = cs.CustID		
WHERE ci.srecommend IN (SELECT custid FROM #supers)  
		AND ci.roleid = 2  
		AND ci.Enabled = 1      
		AND cs.SportType = @SportType
	
		
SELECT cs.CustID,ci.recommend,ci.mrecommend,ci.srecommend, cs.SportType,cs.BetType,cs.adiscount AS Discount
INTO #MasterComm
FROM dbo.CustInfo ci
	INNER JOIN dbo.custsettinggame cs WITH (NOLOCK) ON ci.CustID = cs.CustID	
WHERE ci.srecommend IN (SELECT custid FROM #supers) 
		AND ci.roleid = 3  
		AND ci.Enabled = 1      
		AND cs.SportType = @SportType 
	
SELECT cs.CustID, cs.SportType,cs.BetType,cs.sdiscount AS Discount
INTO #SuperComm
FROM dbo.CustInfo ci
	INNER JOIN dbo.custsettinggame cs WITH (NOLOCK) ON ci.CustID = cs.CustID		
WHERE ci.srecommend IN (SELECT custid FROM #supers)  
		AND ci.roleid = 4  
		AND ci.Enabled = 1      
		AND cs.SportType = @SportType

---- 36. Super''s Discount < Master''s Discount
INSERT INTO ##CheckCommResult_Credit (RuleId, BetType, SportType, CustIdA, CustIdB, ValueA, ValueB)   
SELECT 36 AS RuleId, css.BetType, css.SportType, css.CustId, csm.CustId, css.Discount, csm.Discount  
FROM #SuperComm css 
	INNER JOIN #MasterComm csm ON csm.BetType = css.BetType AND csm.SportType = css.SportType AND csm.srecommend = css.custid
WHERE css.Discount < csm.Discount

----PRINT '37. Master''s Discount < Agent''s Discount'
INSERT INTO ##CheckCommResult_Credit (RuleId, BetType, SportType, CustIdA, CustIdB, ValueA, ValueB)  
SELECT 37 AS RuleId, csa.BetType, csa.SportType, csm.CustId, csa.CustId, csm.Discount, csa.Discount  
FROM #AgentComm csa
	INNER JOIN #MasterComm csm ON csm.BetType = csa.BetType AND csm.SportType = csa.SportType AND csa.mrecommend = csm.CustID
WHERE csm.Discount < csa.Discount

----PRINT '38. Agent''s Discount < Player''s Discount'
INSERT INTO ##CheckCommResult_Credit (RuleId, BetType, SportType, CustIdA, CustIdB, ValueA, ValueB)  
SELECT 38 AS RuleId, csa.BetType, csa.SportType, csa.CustId, csmem.CustId, csa.Discount, csmem.PlayerDiscount
FROM #AgentComm csa
	INNER JOIN #MemberComm csmem ON csmem.BetType = csa.BetType AND csmem.SportType = csa.SportType AND csmem.recommend = csa.CustID
WHERE csa.Discount < csmem.PlayerDiscount

----PRINT '39. SuperDiscount < MasterDiscount on member level'
INSERT INTO ##CheckCommResult_Credit (RuleId, BetType, SportType, CustIdA, CustIdB, ValueA, ValueB)  
SELECT 39 as RuleId, csmem.BetType, csmem.SportType, csmem.CustId, csmem.CustId, csmem.SuperDiscount, csmem.MasterDiscount
FROM #MemberComm csmem
WHERE csmem.SuperDiscount < csmem.MasterDiscount

----PRINT '40. MasterDiscount < AgentDiscount on member level'
INSERT INTO ##CheckCommResult_Credit (RuleId, BetType, SportType, CustIdA, CustIdB, ValueA, ValueB)  
SELECT 40 as RuleId, csmem.BetType, csmem.SportType, csmem.CustId, csmem.CustId, csmem.MasterDiscount, csmem.AgentDiscount
FROM #MemberComm csmem
WHERE csmem.MasterDiscount < csmem.AgentDiscount

----PRINT '41. AgentDiscount < PlayerDiscount on member level'
INSERT INTO ##CheckCommResult_Credit (RuleId, BetType, SportType, CustIdA, CustIdB, ValueA, ValueB)  
SELECT 41 as RuleId, csmem.BetType, csmem.SportType, csmem.CustId, csmem.CustId, csmem.AgentDiscount, csmem.PlayerDiscount
FROM #MemberComm csmem
WHERE csmem.AgentDiscount < csmem.PlayerDiscount
		