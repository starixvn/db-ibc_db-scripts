/*
	Created: Helen
	Date: 20160824
	Task: prepare data for tmpCustGameType_LCS

     
*/
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'tmpCustGameType_LCS' and type = 'u')
    DROP TABLE tmpCustGameType_LCS
GO  

CREATE TABLE tmpCustGameType_LCS(CustID INT PRIMARY KEY, StakeLevelList VARCHAR(100))

GO

--Use SSIS to import data for 
/*
Source: DBCASINOADMIN.CasinoAdmin - with select Query below
Destination: DBCUST.custDB.tmpCustGameType_LCS
*/   
SELECT CustID,StakeLevelList
FROM DBBingoAdmin.LiveCasinoAdmin.dbo.CustGameType WITH (NOLOCK)
WHERE GameTypeID = 108 