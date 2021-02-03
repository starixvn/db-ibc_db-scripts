/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20210202@Sophia
	DB : DBTXN-bodb02
	Task: Update Srecommend [Redmine: #149923]
*/

SELECT TransID 
INTO #TransID  
FROM bettrans WITH (NOLOCk) 
WHERE Bettype = 17004



UPDATE b
SET b.srecommend = c.srecommend
FROM Bettrans b WITH (NOLOCK) 
INNER JOIN CUSTDB.dbo.Custinfo c WITH (NOLOCK) 
ON c.CustID = b.CustID AND c.RoleID = 1
WHERE b.TransID IN (Select TransID FROM #TransID) 

