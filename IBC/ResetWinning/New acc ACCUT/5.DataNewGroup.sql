USE [bodb_ACC]
GO 

-- SB
INSERT INTO dbo.Acc_GroupExtraPTSetting (SuperId, GroupId, GroupName,ProductId, Sporttype,SubProduct ,ExtraPT )
SELECT P.CustID, 19 AS GroupId, P.GroupName, 0 as ProductId ,0 as Sporttype,'' as SubProduct, 0 as ExtraPT
FROM  DBAGE.bodb_Age.dbo.Acc_CustGroup P WITH (NOLOCK)
WHERE GroupName = 'ACCUT'
GO

--------------  
 
UPDATE dbo.Acc_GroupExtraPTSetting
SET ProductId = 1, ExtraPT = 0.015
WHERE GroupName = 'ACCUT'

GO
 

---- Special update for Metric Gaming 

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, Sporttype, 'MG-SuperLive' AS SubProduct, ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
	AND GroupName = 'ACCUT'
GO


---- Special update for Bettrade

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, Sporttype, 'BT-Comm' AS SubProduct, 0 AS ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
AND GroupName = 'ACCUT'
GO

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, Sporttype, 'BT-Sold' AS SubProduct, 0 AS ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
AND GroupName = 'ACCUT'
GO

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, Sporttype, 'BT-Bought' AS SubProduct, 0 AS ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
AND GroupName = 'ACCUT'
GO



---- Special update for MuayThai

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, 44 as Sporttype, '' AS SubProduct, ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
AND GroupName = 'ACCUT'
GO
--------------------------------------------------------------------------------
-- CASINO
INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, 6, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName  = 'ACCUT'
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- BINGO
UNION ALL
SELECT SuperId, GroupId, GroupName, 7, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName = 'ACCUT'
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- NUMBER GAME
UNION ALL
SELECT SuperId, GroupId, GroupName, 3, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName = 'ACCUT'
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- VIRTUAL SPORTS
UNION ALL
SELECT SuperId, GroupId, GroupName, 5, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName = 'ACCUT'
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- KENO
UNION ALL
SELECT SuperId, GroupId, GroupName, 8, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName = 'ACCUT'
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- GOLD DELUXE 
UNION ALL
SELECT SuperId, GroupId, GroupName, 12, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName = 'ACCUT'
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- LIVE CASINO
UNION ALL
SELECT SuperId, GroupId, GroupName, 4, Sporttype, SubProduct, 0.13
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName = 'ACCUT'
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

GO


---------------------------------------------------


-- Update FromDate, ToDate
UPDATE dbo.Acc_GroupExtraPTSetting
SET FromDate = CONVERT(DATETIME, '20160323')
	,ToDate = CONVERT(DATETIME, '99991231')
WHERE GroupName = 'ACCUT' 