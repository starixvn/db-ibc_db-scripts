/*
	Created: Elodie
	Date: 2017-03-17
	Task: Update bit values to 1 for bits 4 (NG2)
	DB: DBCust/CustDB
*/   
USE CustDB
GO

SELECT c.CustID
INTO #supers
FROM CustProductStatus CPS (NOLOCK)
	INNER JOIN Customer C (NOLOCK) ON CPS.CustID = C.custid
	INNER JOIN Custinfo CI (NOLOCK) ON CPS.CustID = CI.custid
WHERE CI.roleid = 4 AND dbo.f_GetProductStatus (cps.bitmapIsHidden,4) = 0
	AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND CI.Enabled = 1
	AND site <> '789y'

--6460 affected rows
UPDATE cps
SET bitmapIsHidden = dbo.f_GenerateProductStatus(bitmapIsHidden, 4, 1),
	bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, 4, 1)
FROM #supers s
	INNER JOIN custinfo ci WITH (NOLOCK) ON s.custid = ci.srecommend
	INNER JOIN CustProductStatus CPS WITH (NOLOCK) ON ci.custid = CPS.CustID 
