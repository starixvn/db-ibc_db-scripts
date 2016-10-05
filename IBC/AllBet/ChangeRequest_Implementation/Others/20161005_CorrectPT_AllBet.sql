CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		-- Production
		AND ci.site in ('INDO','755555','Koribc')
		AND ci.custid <> 72
	) OR ci.custid IN (2,4,13,15) -- DUMMY 

UPDATE cs
SET MasterPT = SuperPT, AgentPT = SuperPT
FROM CustPTSetting3rd_Agent cs WITH (ROWLOCK,UPDLOCK)
INNER JOIN #supers ci WITH (NOLOCK) ON cs.CustID = ci.custid
WHERE SportType = 211 
