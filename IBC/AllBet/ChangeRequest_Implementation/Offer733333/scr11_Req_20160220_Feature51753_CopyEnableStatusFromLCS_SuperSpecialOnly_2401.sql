/*
	Created: Helen	
	Task: Initialize Product Status of AllBet for Credit customers
	DB: DBCUST/CustDB
	Date: 20160820
*/
-- only offer Super
UPDATE cs
	SET bitmapIsDisabled = CASE WHEN ci.SyncLiveCasino = 1 AND ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 6, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.roleid = 4 
/*
AND ci.username IN ('S69RD',
'S69TB',
'S69W',
'S69K',
'S69RP',
'S69NT',
'S56TB',
'S56TC',
'S56TH',
'S56TA',
'S56TD',
'S56TT',
'S56I',
'S56D',
'S56AI',
'S56II')
*/
