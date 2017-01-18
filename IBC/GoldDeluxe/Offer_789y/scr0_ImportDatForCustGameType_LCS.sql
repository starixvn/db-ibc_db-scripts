/*
	Created: Johnson
	Date: 2017-01-13
	Task: 
*/
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'CustGameType_LCS' and type = 'u')
    DROP TABLE CustGameType_LCS
GO  

CREATE TABLE CustGameType_LCS(
		CustID INT 
		,GameTypeID INT
		, StakeLevelList VARCHAR(100)
		,PRIMARY KEY CLUSTERED( CustID ASC, GameTypeID ASC) WITH (IGNORE_DUP_KEY = ON) 
)


GO

--Use SSIS to import data for 
/*
Source: DBCASINOADMINCS.LiveCasinoAdmin - with select Query below
Destination: DBCUST.custDB.CustGameType_LCS


*/   
SELECT custid
INTO #supers
FROM customer c WITH(NOLOCK)
WHERE site = '789y'
	AND roleID = 4
GO	

SELECT CustID,GameTypeID,StakeLevelList
FROM CustGameType cg WITH (NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cg.custid 
WHERE GameTypeID IN (108,109)
	AND ci.srecommend IN (select custid FROM #supers)