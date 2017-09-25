USE [CustDB]
GO

/*
	Created by Percy
	Date: 2017-09-25
	DB: DBCUST.CustDB
	Task: Import data
*/

INSERT INTO [dbo].[Acc_GroupExtraPTSetting]
(
	[SuperId]
    ,[GroupId]
    ,[GroupName]
    ,[ProductId]
    ,[Sporttype]
    ,[SubProduct]
    ,[ExtraPT]
    ,[FromDate]
    ,[ToDate]
)
SELECT
	[SuperId]
    ,[GroupId]
    ,[GroupName]
    ,[ProductId]
    ,[Sporttype]
    ,[SubProduct]
    ,[ExtraPT]
    ,[FromDate]
    ,[ToDate]
FROM DBACC.bodb_ACC.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)

INSERT INTO [dbo].[Acc_GroupExtraPT_Product]
(
    [GroupId]
    ,[GroupName]
    ,[ProductId]
    ,[Sporttype]
    ,[SubProduct]
    ,[ExtraPT]
    ,[FromDate]
    ,[ToDate]
)
SELECT
    [GroupId]
    ,[GroupName]
    ,[ProductId]
    ,[Sporttype]
    ,[SubProduct]
    ,[ExtraPT]
    ,[FromDate]
    ,[ToDate]
FROM DBACC.bodb_ACC.dbo.Acc_GroupExtraPT_Product WITH (NOLOCK)