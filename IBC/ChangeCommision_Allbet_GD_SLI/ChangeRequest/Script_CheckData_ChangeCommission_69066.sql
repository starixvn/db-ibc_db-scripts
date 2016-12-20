/*
	Created: Helen
	Task: Script to check data after run - Change commission for Super level - Remine:https://nexdev.net/issues/69066
	DB: DBCUST/CustDB
	Date: 20161220	
*/ 

CREATE TABLE #Cust_tmp (CustID INT PRIMARY KEY,roleID INT)

INSERT INTO #Cust_tmp (CustID,roleID)
SELECT ci.custid,ci.roleid
FROM custInfo ci (NOLOCK) 
WHERE ci.srecommend IN (2138601,2251491) AND roleid IN (1,3,4)

PRINT  'ALLBET' 
SELECT COUNT(1) 
FROM CustDiscount3rd_Agent  cd (NOLOCK)
	INNER JOIN #Cust_tmp c ON cd.CustID = c.CustID AND roleID = 3
WHERE cd.SportType = 211 AND Discount <> 0.009

SELECT COUNT(1)
FROM  CustDiscount3rd_Member cd (NOLOCK)
	INNER JOIN #Cust_tmp c ON cd.CustID = c.CustID
WHERE cd.SportType = 211 AND C.roleID = 1 AND (SuperDiscount <> 0.009 OR MasterDiscount <> 0.009)

PRINT 'SLI Live Casino & GD ' 
-- SLI & GD
SELECT COUNT(1)
FROM  CustSettingGame cs WITH(NOLOCK)
	INNER JOIN #Cust_tmp ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.roleid = 1
WHERE cs.sporttype IN (162,255) AND (sdiscount <> 0.009 OR adiscount <> 0.009)

SELECT COUNT(1)
FROM  CustSettingGame cs WITH(NOLOCK)
	INNER JOIN #Cust_tmp ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.roleid = 3
WHERE cs.sporttype IN (162,255) AND adiscount <> 0.009