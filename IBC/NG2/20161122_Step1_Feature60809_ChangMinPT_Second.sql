/*
	Created: Elodie
	Date: 20161122
	Task: Change NG2 MinPT of Super for XT, XTA, XTB, XTC, XTD line
	DB: DBCUST/CustDB
*/
USE CustDB
GO

CREATE TABLE #Super (CustID INT)

INSERT INTO #Super (CustID)
select CustID
FROM dbo.custInfo WITH (NOLOCK)
WHERE username IN ('XT', 'XTA', 'XTB', 'XTC', 'XTD') AND roleid = 4

UPDATE cs
SET cs.MinPT = 80
FROM dbo.CustPTSetting3rd_Agent cs WITH (ROWLOCK,UPDLOCK)
	INNER JOIN #Super s ON s.CustID = cs.CustID
WHERE cs.SportType BETWEEN 213 AND 218

