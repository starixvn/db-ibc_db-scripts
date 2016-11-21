/*
	Created: Elodie
	Date: 20161121
	Task: Change NG2 MinPT of Super for ACCYEN889 line
	DB: DBCUST/CustDB
*/
USE CustDB
GO

CREATE TABLE #Super (CustID INT)

INSERT INTO #Super (CustID)
select CustID
FROM DBAGE.bodb_age.dbo.Acc_CustGroup with (Nolock)
WHERE GroupName = 'ACCYEN889'
	AND CustID <> 595561 -- SC

UPDATE cs
SET cs.MinPT = 80
FROM dbo.CustPTSetting3rd_Agent cs WITH (ROWLOCK,UPDLOCK)
	INNER JOIN #Super s ON s.CustID = cs.CustID
WHERE cs.SportType BETWEEN 213 AND 218

