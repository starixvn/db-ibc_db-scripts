/*
	Created: Helen
	Date: 20160824
	Task: prepare data for tmpCustGameType
	DB: DBCUST/06/TP/MNL.bodb02	
*/ 

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'CustGameType_LCS' and type = 'u')
    DROP TABLE CustGameType_LCS
GO  

CREATE TABLE CustGameType_LCS(CustID INT PRIMARY KEY, StakeLevelList_LC VARCHAR(100))

GO

INSERT INTO CustGameType_LCS (CustID,StakeLevelList_LC)
SELECT Custid, StakeLevelList
FROM DBBingoAdmin.LiveCasinoAdmin.dbo.CustGameType WITH (NOLOCK)
WHERE GameTypeID = 108 