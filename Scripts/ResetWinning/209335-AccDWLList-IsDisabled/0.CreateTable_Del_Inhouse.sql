/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20240814@Lewis
	DB: DBCUST-CustDB
	Task:  Add new column IsDisabled on Acc_DWLList, Acc_DWLList_xtest tables [RedmineId:  #209319]
*/

USE CustDB
GO

--[Acc_DWLList_Del_InHouse]
CREATE TABLE [dbo].[Acc_DWLList_Del_InHouse](
	[custid] [int] NOT NULL,
	[product] [varchar](50) NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL

) ON [DATA]
GO

ALTER TABLE [dbo].[Acc_DWLList_Del_InHouse] ADD CONSTRAINT [DF_Acc_DWLList_Del_InHouse_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime] 
GO

CREATE CLUSTERED INDEX CIX_Acc_DWLList_Del_InHouse ON Acc_DWLList_Del_InHouse([RepUpdateTime]) ON [DATA]
GO

--[Acc_DWLList_xtest_Del_InHouse]
CREATE TABLE [dbo].Acc_DWLList_xtest_Del_InHouse(
	[custid] [int] NOT NULL,
	[product] [varchar](50) NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL

) ON [DATA]
GO

ALTER TABLE [dbo].Acc_DWLList_xtest_Del_InHouse ADD CONSTRAINT [DF_Acc_DWLList_xtest_Del_InHouse_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime] 
GO

CREATE CLUSTERED INDEX CIX_Acc_DWLList_xtest_Del_InHouse ON Acc_DWLList_xtest_Del_InHouse([RepUpdateTime]) ON [DATA]
GO

--[Acc_DWLList_ExtraPT_Del_InHouse]
CREATE TABLE [dbo].Acc_DWLList_ExtraPT_Del_InHouse(
	[CustId] [int] NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL

) ON [DATA]
GO

ALTER TABLE [dbo].Acc_DWLList_ExtraPT_Del_InHouse ADD  CONSTRAINT [DF_Acc_DWLList_ExtraPT_Del_InHouse_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

CREATE CLUSTERED INDEX CIX_Acc_DWLList_ExtraPT_Del_InHouse ON Acc_DWLList_ExtraPT_Del_InHouse([RepUpdateTime]) ON [DATA]
GO

--[Acc_DWLList_ExtraPT_xtest_Del_InHouse]
CREATE TABLE [dbo].Acc_DWLList_ExtraPT_xtest_Del_InHouse(
	[CustId] [int] NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL

) ON [DATA]
GO

ALTER TABLE [dbo].Acc_DWLList_ExtraPT_xtest_Del_InHouse ADD  CONSTRAINT [DF_Acc_DWLList_ExtraPT_xtest_Del_InHouse_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

CREATE CLUSTERED INDEX CIX_Acc_DWLList_ExtraPT_xtest_Del_InHouse ON Acc_DWLList_ExtraPT_xtest_Del_InHouse([RepUpdateTime]) ON [DATA]
GO


