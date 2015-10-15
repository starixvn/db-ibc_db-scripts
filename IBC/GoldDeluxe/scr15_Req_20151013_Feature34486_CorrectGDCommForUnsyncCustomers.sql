 /*
	Created: Johnson
	Date: 2015-10-13
	Task: correct GD comm for un-sync customers list
	DB: DBCUST/CUSTDB
 */
 --deploy table CheckGDComm on DBCUST 
 CREATE TABLE CheckCommGD (custid INT, username varchar(30), discountA decimal(9,8), custidB INT, discountB decimal(9,8),ruleID INT)
 GO

CREATE TABLE #supers (custid int, isfinished bit default(0))

INSERT INTO #supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
	INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
	INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4 	
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	and s.islicensee = 0
GO

DECLARE @srecommend INT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
  --20141113@Johnson: hardcode customer list not give commission for downlines	   
    DECLARE @tblCustList TABLE(custid INT, roleid INT)
	
	INSERT INTO @tblCustList(custid, roleid)
			 SELECT	52466		,	2	--	8RM
	UNION SELECT	134456		,	2	--	XYZRM
	UNION SELECT	11656507	,	2	--	J00101311101
	UNION SELECT	11656514	,	2	--	J00101311102
	UNION SELECT	11656525	,	2	--	J00101311150
	UNION SELECT	11642591	,	2	--	XXCH60011100
	UNION SELECT	3645795		,	2	--	999RMA01
	UNION SELECT	3645796		,	2	--	999RMA02
	UNION SELECT	3645798		,	2	--	999RMA50
	UNION SELECT	4430389		,	2	--	C527A
	UNION SELECT	4430395		,	2	--	C527B
	UNION SELECT	6201735		,	2	--	6HK2501
	UNION SELECT	15819264	,	2	--	HK000002
	UNION SELECT	1098992		,	1	--	007P
	UNION SELECT	2344		,	1	--	RICHK
	UNION SELECT	753422		,	1	--	MOONSHK
	UNION SELECT	12254453	,	1	--	6666AHK002
	UNION SELECT	15976531	,	1	--	6666AHK005
	UNION SELECT	12295775	,	1	--	10BA
	UNION SELECT	1280		,	1	--	312RMB
	UNION SELECT	1241353		,	1	--	315RMB
	UNION SELECT	1981797		,	1	--	318RMB
	UNION SELECT	4230489		,	1	--	319RMB
	UNION SELECT	4396024		,	1	--	527RMB
	UNION SELECT	11405172	,	1	--	556RMB
	UNION SELECT	10409086	,	1	--	388RMB
	UNION SELECT	8679169		,	1	--	585RMB
	UNION SELECT	13885522	,	1	--	688HKK
	
	--20150616@Johnson: add more customers into list
	UNION SELECT 	1098992		,	1	-- 	007P
	UNION SELECT 	12295775	,	1	-- 	10BA
	UNION SELECT 	4706215		,	1	-- 	168rmb
	UNION SELECT 	1686		,	1	-- 	239RMB
	UNION SELECT 	1280		,	1	-- 	312rmb
	UNION SELECT 	1241353		,	1	-- 	315RMB
	UNION SELECT 	1981797		,	1	-- 	318RMB
	UNION SELECT 	4230489		,	1	-- 	319RMB
	UNION SELECT 	10409086	,	1	-- 	388rmb
	UNION SELECT 	4396024		,	1	-- 	527RMB
	UNION SELECT 	11405172	,	1	-- 	556RMB
	UNION SELECT 	8679169		,	1	-- 	585RMB
	UNION SELECT 	13885522	,	1	-- 	688HKK
	UNION SELECT 	16698297	,	1	-- 	789RMB
	UNION SELECT 	753422		,	1	-- 	MOONSHK
	UNION SELECT 	1540595		,	1	-- 	08HK
	UNION SELECT 	15976531	,	1	-- 	6666AHK005
	UNION SELECT 	640041		,	1	-- 	M3000
	
	--UUS accounnts for testing
	UNION SELECT	14180041	,	2	--	supertestUAT0101
	UNION SELECT	14228743	,	1	--	SUPERTEST20000000
	UNION SELECT	14497432	,	1	--	SUPERTEST20000001
	--End customer list------------------------------------------

INSERT INTO CheckCommGD(custid, username, discountA, custidB, discountB,ruleID)	
SELECT ci.custid as custid,ci.username, cs.sdiscount as discountA, ci.srecommend as custidB, scs.sdiscount as discountB,1--'s1<>s4'
FROM custsettingGame cs WITH(NOLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend
												AND scs.sporttype = cs.sporttype
												AND scs.bettype = cs.bettype
WHERE ci.srecommend = @srecommend 
	AND ci.roleid = 1
	AND ci.enabled = 1	
	AND ci.recommend NOT IN (SELECT custid FROM @tblCustList WHERE roleid =2)
    AND ci.custid NOT IN (SELECT custid FROM @tblCustList WHERE roleid =1)           
    AND cs.sporttype = 255
    AND cs.bettype = 1701
    AND cs.sdiscount <> scs.sdiscount
    
--select * from #CheckCommGD

INSERT INTO CheckCommGD(custid, username, discountA, custidB, discountB,ruleID)	
SELECT ci.custid as custid,ci.username, cs.adiscount as discountA, ci.mrecommend as custidB, mcs.adiscount as discountB,2--'m1<>m3'
FROM custsettingGame cs WITH(NOLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
												AND mcs.sporttype = cs.sporttype
												AND mcs.bettype = cs.bettype
WHERE ci.srecommend = @srecommend 
	AND ci.roleid = 1
	AND ci.enabled = 1	
	AND ci.recommend NOT IN (SELECT custid FROM @tblCustList WHERE roleid =2)
    AND ci.custid NOT IN (SELECT custid FROM @tblCustList WHERE roleid =1)           
    AND cs.sporttype = 255
    AND cs.bettype = 1701
    AND cs.adiscount <> mcs.adiscount   

INSERT INTO CheckCommGD(custid, username, discountA, custidB, discountB,ruleID)	
SELECT ci.custid as custid,ci.username, cs.discount as discountA, ci.recommend as custidB, acs.discount as discountB,3--'a1<>a2'
FROM custsettingGame cs WITH(NOLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid = ci.recommend
												AND acs.sporttype = cs.sporttype
												AND acs.bettype = cs.bettype
WHERE ci.srecommend = @srecommend 
	AND ci.roleid = 1
	AND ci.enabled = 1	
	AND ci.recommend NOT IN (SELECT custid FROM @tblCustList WHERE roleid =2)
    AND ci.custid NOT IN (SELECT custid FROM @tblCustList WHERE roleid =1)           
    AND cs.sporttype = 255
    AND cs.bettype = 1701
    AND cs.discount <> acs.discount     
END    
GO    
    --select * from CheckCommGD
    --order by custid, ruleID
CREATE TABLE #tmp (custid INT, ruleID INT)

DELETE #tmp

UPDATE top (10000) CheckCommGD
SET isfinished = 1
OUTPUT DELETED.Custid, DELETED.RuleID
INTO #tmp
WHERE isfinished = 0
GO


UPDATE cs
SET sdiscount = scs.sdiscount
FROM CustSettingGame cs  WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	INNER JOIN CustSettingGame scs  WITH(NOLOCK)  ON scs.CustID = ci.srecommend
							AND cs.Sporttype = scs.sporttype
							AND cs.Bettype = scs.bettype
WHERE ci.custid IN (select custid from #tmp where ruleID = 1)
	AND cs.sporttype = 255 
	AND cs.bettype = 1701
	AND scs.sdiscount <> cs.sdiscount


UPDATE cs
SET adiscount = scs.adiscount
FROM CustSettingGame cs  WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	INNER JOIN CustSettingGame scs  WITH(NOLOCK)  ON scs.CustID = ci.mrecommend
							AND cs.Sporttype = scs.sporttype
							AND cs.Bettype = scs.bettype
WHERE ci.custid IN (select custid from #tmp where ruleID = 2)
	AND cs.sporttype = 255 
	AND cs.bettype = 1701
	AND scs.adiscount <> cs.adiscount					
 
UPDATE cs
SET discount = scs.discount
FROM CustSettingGame cs  WITH(UPDLOCK,ROWLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.CustID = ci.recommend
							AND cs.Sporttype = scs.sporttype
							AND cs.Bettype = scs.bettype
WHERE ci.custid IN (select custid from #tmp where ruleID = 3)
	AND cs.sporttype = 255 
	AND cs.bettype = 1701
	AND scs.discount <> cs.discount
 