USE [CustDB]
GO

/*
Created: 20191220@Sophia
Task: Change Index of Acc_GroupExtraPTSetting [Redmine :#122071]
DB: DBCUST.CUSTDB
*/

/****** Object:  Index [PK_Acc_GroupExtraPTSetting]    Script Date: 12/20/2019 9:41:16 AM ******/
ALTER TABLE [dbo].[Acc_GroupExtraPTSetting] DROP CONSTRAINT [PK_Acc_GroupExtraPTSetting]
GO

 
/****** Object:  Index [PK_Acc_GroupExtraPTSetting_New]    Script Date: 12/20/2019 9:41:31 AM ******/
ALTER TABLE [dbo].[Acc_GroupExtraPTSetting] ADD  CONSTRAINT [PK_Acc_GroupExtraPTSetting] PRIMARY KEY CLUSTERED 
(
	[SuperId] ASC,
	[ProductId] ASC,
	[Sporttype] ASC,
	[SubProduct] ASC,
	[ToDate] ASC,
	[GroupId] ASC
) ON [DATA]
GO


