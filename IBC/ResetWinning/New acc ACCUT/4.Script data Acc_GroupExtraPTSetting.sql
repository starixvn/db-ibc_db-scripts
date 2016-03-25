USE [bodb_ACC]
GO

TRUNCATE TABLE Acc_GroupExtraPTSetting

-- SB
INSERT INTO dbo.Acc_GroupExtraPTSetting (SuperId, GroupId, GroupName,ProductId, Sporttype,SubProduct ,ExtraPT )
SELECT P.CustID, E.GroupId, E.GroupName,0 as ProductId ,0 as Sporttype,'' as SubProduct, 0 as ExtraPT
FROM  DBAGE.bodb_Age.dbo.Acc_CustGroup P WITH (NOLOCK)
INNER JOIN dbo.Acc_DWLList_ExtraPT E
	ON P.GroupName = E.GroupName
WHERE P.GroupName IN ( 
'ACCMKK',
'MKK99',
'ACCTHAI',
'ACCTHAI2',
'ACCTHAI56',
'ACCTHAI99',
'INDO2',
'INDO56',
'INDOBS',
'INDOWIN',
'ACCDDD',
'ACCIN',
'ACCIRR',
'ACCUT2',
'ACCYEN789',
'ACCYEN889',
'ACCNTD',
'ACCUT')
GO

--------------
UPDATE dbo.Acc_GroupExtraPTSetting
SET ProductId = 1, ExtraPT = 0.03
WHERE GroupName IN ('ACCMKK', 'MKK99', 'accthai2', 'ACCTHAI56', 'ACCTHAI99', 'INDO2','INDO56', 'INDOBS', 'INDOWIN', 'ACCDDD', 'ACCIN')
GO

UPDATE dbo.Acc_GroupExtraPTSetting
SET ProductId = 1, ExtraPT = 0.05
WHERE GroupName IN ('ACCTHAI')
GO

UPDATE dbo.Acc_GroupExtraPTSetting
SET ProductId = 1, ExtraPT = 0.015
WHERE GroupName IN ('ACCIRR', 'ACCUT2', 'ACCNTD','ACCUT')
GO

UPDATE dbo.Acc_GroupExtraPTSetting
SET ProductId = 1, ExtraPT = 0.02
WHERE GroupName IN ('accyen789')
GO

UPDATE dbo.Acc_GroupExtraPTSetting
SET ProductId = 1, ExtraPT = 0.025
WHERE GroupName IN ('ACCYEN889')
GO

------FOR BC - SB

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, 18, 'BC', ProductId, Sporttype, SubProduct, 0.02
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName IN ('accthai2', 'ACCTHAI56', 'ACCTHAI99')
GO


---- Special update for Metric Gaming 

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, Sporttype, 'MG-SuperLive' AS SubProduct, ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
GO


---- Special update for Bettrade

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, Sporttype, 'BT-Comm' AS SubProduct, 0 AS ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
GO

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, Sporttype, 'BT-Sold' AS SubProduct, 0 AS ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
GO

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, Sporttype, 'BT-Bought' AS SubProduct, 0 AS ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
GO



---- Special update for MuayThai

INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, ProductId, 44 as Sporttype, '' AS SubProduct, ExtraPT
FROM dbo.Acc_GroupExtraPTSetting
WHERE ProductID = 1 AND SubProduct = ''
GO
--------------------------------------------------------------------------------
-- CASINO
INSERT INTO dbo.Acc_GroupExtraPTSetting
(SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT)
SELECT SuperId, GroupId, GroupName, 6, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName IN ('ACCIRR', 'ACCUT2', 'accyen789', 'ACCYEN889', 'ACCNTD','ACCUT')
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- BINGO
UNION ALL
SELECT SuperId, GroupId, GroupName, 7, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName IN ('ACCIRR', 'ACCUT2', 'accyen789', 'ACCYEN889', 'ACCNTD','ACCUT')
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- NUMBER GAME
UNION ALL
SELECT SuperId, GroupId, GroupName, 3, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName IN ('ACCIRR', 'ACCUT2', 'accyen789', 'ACCYEN889', 'ACCNTD','ACCUT')
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- VIRTUAL SPORTS
UNION ALL
SELECT SuperId, GroupId, GroupName, 5, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName IN ('ACCIRR', 'ACCUT2', 'accyen789', 'ACCYEN889', 'ACCNTD','ACCUT')
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- KENO
UNION ALL
SELECT SuperId, GroupId, GroupName, 8, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName IN ('ACCIRR', 'ACCUT2', 'accyen789', 'ACCYEN889', 'ACCNTD','ACCUT')
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- GOLD DELUXE 
UNION ALL
SELECT SuperId, GroupId, GroupName, 12, Sporttype, SubProduct, 0.05
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName IN ('ACCIRR', 'ACCUT2', 'accyen789', 'ACCYEN889', 'ACCNTD','ACCUT')
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

-- LIVE CASINO
UNION ALL
SELECT SuperId, GroupId, GroupName, 4, Sporttype, SubProduct, 0.13
FROM dbo.Acc_GroupExtraPTSetting
WHERE GroupName IN ('ACCIRR', 'ACCUT2', 'accyen789', 'ACCYEN889', 'ACCNTD','ACCUT')
AND ProductID = 1 AND SubProduct = '' AND Sporttype = 0 

GO


---------------------------------------------------


-- Update FromDate, ToDate
UPDATE dbo.Acc_GroupExtraPTSetting
SET FromDate = CONVERT(DATETIME, '19000101')
	,ToDate = CONVERT(DATETIME, '99991231')
 
	
-- Update FromDate, ToDate
UPDATE dbo.Acc_GroupExtraPTSetting
SET FromDate = CONVERT(DATETIME, '20160323')
WHERE GroupName = 'ACCUT' 