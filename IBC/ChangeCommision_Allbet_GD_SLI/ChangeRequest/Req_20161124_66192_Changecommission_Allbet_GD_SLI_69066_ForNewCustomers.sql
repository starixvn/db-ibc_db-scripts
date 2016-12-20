/*
	Created: Helen
	Task: Allbet, SLI Live Casino, GD - Change commission for Super level - Remine:https://nexdev.net/issues/69066
	DB: DBCUST/CustDB
	Date: 20161220	
*/ 

DECLARE @maxcustid INT
SET @maxcustid = XXXX

CREATE TABLE #Cust_tmp (CustID INT PRIMARY KEY,roleID INT)

--SLI Live Casino or GD or Allbet
-- DCS 
INSERT INTO #Cust_tmp (CustID,roleID)
SELECT ci.custid,ci.roleid
FROM custInfo ci (NOLOCK) 
WHERE ci.srecommend IN (2138601,2251491) AND ci.custid > @maxcustid AND ((roleid = 3 and CI.reject = 0 AND CI.closed = 0) OR roleid in (1,4)) AND CI.Enabled = 1

PRINT  'Updating ALLBET' 
UPDATE cd
	SET Discount = 0.009
FROM CustDiscount3rd_Agent  cd (ROWLOCK)
	INNER JOIN #Cust_tmp c ON cd.CustID = c.CustID AND roleID = 3
WHERE cd.SportType = 211 

UPDATE cd
	SET SuperDiscount = 0.009,MasterDiscount = 0.009
FROM  CustDiscount3rd_Member cd (ROWLOCK)
	INNER JOIN #Cust_tmp c ON cd.CustID = c.CustID
WHERE cd.SportType = 211 AND C.roleID = 1

PRINT 'Updating SLI Live Casino & GD ' 
-- SLI & GD
UPDATE cs
	SET sdiscount = 0.009,adiscount = 0.009
FROM  CustSettingGame cs WITH(ROWLOCK)
	INNER JOIN #Cust_tmp ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.roleid = 1
WHERE cs.sporttype IN (162,255)

UPDATE cs
	SET adiscount = 0.009
FROM  CustSettingGame cs WITH(ROWLOCK)
	INNER JOIN #Cust_tmp ci WITH(NOLOCK) ON ci.custid = cs.custid AND ci.roleid = 3
WHERE cs.sporttype IN (162,255)
			
DROP TABLE #Cust_tmp
