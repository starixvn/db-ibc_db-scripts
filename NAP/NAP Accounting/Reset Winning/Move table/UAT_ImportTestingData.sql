USE [CustDB]
GO

/*
	Created by Percy
	Date: 2017-10-03
	DB: DBCUST.CustDB
	Task: Extra PT Setting - Import testing data
*/

INSERT INTO dbo.Acc_GroupExtraPT_Product (GroupId, GroupName, ProductID, Sporttype, SubProduct, FromDate, ToDate, ExtraPT)
SELECT GroupId, GroupName + '_TEST', ProductID, Sporttype, SubProduct, FromDate, ToDate, ExtraPT
FROM DBACC.bodb_ACC.dbo.Acc_GroupExtraPT_Product WITH (NOLOCK)
WHERE GroupId IN (1,2,3)

INSERT INTO dbo.Acc_GroupExtraPTSetting (SuperId, GroupId, GroupName, ProductID, Sporttype, SubProduct, FromDate, ToDate, ExtraPT)
SELECT SuperId, GroupId, GroupName + '_TEST', ProductID, Sporttype, SubProduct, FromDate, ToDate, ExtraPT
FROM DBACC.bodb_ACC.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
WHERE GroupId IN (1,2,3)