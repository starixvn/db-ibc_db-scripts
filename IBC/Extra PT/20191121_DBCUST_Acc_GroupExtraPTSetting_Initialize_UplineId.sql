USE CustDB
GO

/*
	Created: 20191121@Percy
	DB: DBCUST.CustDB
	Task: #122191 - Initialize column UplineId on Extra PT Setting table
		Using for calculate customer counter
*/

-- 468 row(s) affected
UPDATE e
SET e.UplineId = c.UplineId
FROM dbo.Acc_GroupExtraPTSetting e WITH (ROWLOCK)
	INNER JOIN dbo.CustSuper c WITH (NOLOCK) ON e.SuperId = c.custid
WHERE c.UplineId IS NOT NULL
	AND e.UplineId IS NULL
GO