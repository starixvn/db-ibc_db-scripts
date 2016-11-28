/*
	Created: Elodie
	Date: 20161128
	Task: Change NG2 MinPT of Super for ACCYEN668 and ACCYEN789 line
	DB: DBCUST/CustDB
*/
USE CustDB
GO

CREATE TABLE #Super (CustID INT)

INSERT INTO #Super (CustID)
select CustID
FROM DBAGE.bodb_age.dbo.Acc_CustGroup with (Nolock)
WHERE GroupName IN ('ACCYEN668', 'ACCYEN789') AND RoleID = 4

UPDATE cs
SET cs.MinPT = 80
FROM dbo.CustPTSetting3rd_Agent cs WITH (ROWLOCK,UPDLOCK)
	INNER JOIN #Super s ON s.CustID = cs.CustID
WHERE cs.SportType BETWEEN 213 AND 218

