
Use bodb_Summary
GO

/*
Create: 20190321@Sophia
Task: DN88 table sum paritition - 110591
DB: DBSUM.bodb_Summary (DB052,DB053)
*/ 
 
--1
--Create files and file groups
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M01]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M02]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M03]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M04]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M05]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M06]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M07]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M08]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M09]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M10]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M11]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_19M12]

ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M01]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M02]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M03]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M04]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M05]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M06]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M07]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M08]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M09]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M10]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M11]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_20M12]

ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M01]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M02]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M03]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M04]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M05]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M06]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M07]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M08]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M09]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M10]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M11]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_21M12]

ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M01]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M02]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M03]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M04]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M05]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M06]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M07]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M08]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M09]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M10]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M11]
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_22M12]

ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss_Old_MAX]

 
 ----DB215
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M01', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M01.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M01]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M02', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M02.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M02]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M03', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M03.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M03]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M04', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M04.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M04]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M05', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M05.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M05]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M06', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M06.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M06]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M07', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M07.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M07]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M08', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M08.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M08]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M09', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M09.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M09]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M10', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M10.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M10]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M11', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M11.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M11]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_19M12', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_19M12.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_19M12]

ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M01', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M01.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M01]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M02', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M02.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M02]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M03', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M03.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M03]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M04', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M04.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M04]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M05', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M05.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M05]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M06', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M06.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M06]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M07', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M07.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M07]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M08', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M08.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M08]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M09', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M09.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M09]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M10', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M10.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M10]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M11', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M11.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M11]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_20M12', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_20M12.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_20M12]

ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M01', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M01.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M01]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M02', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M02.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M02]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M03', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M03.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M03]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M04', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M04.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M04]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M05', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M05.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M05]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M06', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M06.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M06]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M07', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M07.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M07]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M08', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M08.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M08]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M09', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M09.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M09]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M10', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M10.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M10]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M11', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M11.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M11]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_21M12', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_21M12.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_21M12]

ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M01', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M01.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M01]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M02', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M02.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M02]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M03', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M03.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M03]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M04', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M04.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M04]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M05', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M05.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M05]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M06', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M06.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M06]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M07', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M07.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M07]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M08', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M08.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M08]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M09', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M09.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M09]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M10', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M10.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M10]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M11', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M11.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M11]
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss_Old_22M12', filename ='E:\IBC_DB\bodb_Summary\CS_SumWinloss_Old\CS_SumWinloss_Old_22M12.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss_Old_22M12]


--2
--Create partition function
CREATE PARTITION FUNCTION pf_CS_SumWinloss_Old_monthly (SMALLDATETIME) AS
RANGE LEFT FOR VALUES
(    
'2019/01/31',
'2019/02/28',
'2019/03/31',
'2019/04/30',
'2019/05/31',
'2019/06/30',
'2019/07/31',
'2019/08/31',
'2019/09/30',
'2019/10/31',
'2019/11/30',
'2019/12/31',

'2020/01/31',
'2020/02/29',
'2020/03/31',
'2020/04/30',
'2020/05/31',
'2020/06/30',
'2020/07/31',
'2020/08/31',
'2020/09/30',
'2020/10/31',
'2020/11/30',
'2020/12/31',		

'2021/01/31',
'2021/02/28',
'2021/03/31',
'2021/04/30',
'2021/05/31',
'2021/06/30',
'2021/07/31',
'2021/08/31',
'2021/09/30',
'2021/10/31',
'2021/11/30',
'2021/12/31',

'2022/01/31',
'2022/02/28',
'2022/03/31',
'2022/04/30',
'2022/05/31',
'2022/06/30',
'2022/07/31',
'2022/08/31',
'2022/09/30',
'2022/10/31',
'2022/11/30',
'2022/12/31'
		

)

--Create partition schema
CREATE PARTITION SCHEME ps_CS_SumWinloss_Old_monthly
AS PARTITION pf_CS_SumWinloss_Old_monthly
TO
    (
	[CS_SumWinloss_Old_19M01], 
	[CS_SumWinloss_Old_19M02], 
	[CS_SumWinloss_Old_19M03], 
	[CS_SumWinloss_Old_19M04], 
	[CS_SumWinloss_Old_19M05], 
	[CS_SumWinloss_Old_19M06], 
	[CS_SumWinloss_Old_19M07], 
	[CS_SumWinloss_Old_19M08], 
	[CS_SumWinloss_Old_19M09], 
	[CS_SumWinloss_Old_19M10], 
	[CS_SumWinloss_Old_19M11], 
	[CS_SumWinloss_Old_19M12],

	[CS_SumWinloss_Old_20M01],
	[CS_SumWinloss_Old_20M02],
	[CS_SumWinloss_Old_20M03],
	[CS_SumWinloss_Old_20M04],
	[CS_SumWinloss_Old_20M05],
	[CS_SumWinloss_Old_20M06],
	[CS_SumWinloss_Old_20M07],
	[CS_SumWinloss_Old_20M08],
	[CS_SumWinloss_Old_20M09],
	[CS_SumWinloss_Old_20M10],
	[CS_SumWinloss_Old_20M11],
	[CS_SumWinloss_Old_20M12],

	[CS_SumWinloss_Old_21M01],
	[CS_SumWinloss_Old_21M02],
	[CS_SumWinloss_Old_21M03],
	[CS_SumWinloss_Old_21M04],
	[CS_SumWinloss_Old_21M05],
	[CS_SumWinloss_Old_21M06],
	[CS_SumWinloss_Old_21M07],
	[CS_SumWinloss_Old_21M08],
	[CS_SumWinloss_Old_21M09],
	[CS_SumWinloss_Old_21M10],
	[CS_SumWinloss_Old_21M11],
	[CS_SumWinloss_Old_21M12],

	[CS_SumWinloss_Old_22M01],
	[CS_SumWinloss_Old_22M02],
	[CS_SumWinloss_Old_22M03],
	[CS_SumWinloss_Old_22M04],
	[CS_SumWinloss_Old_22M05],
	[CS_SumWinloss_Old_22M06],
	[CS_SumWinloss_Old_22M07],
	[CS_SumWinloss_Old_22M08],
	[CS_SumWinloss_Old_22M09],
	[CS_SumWinloss_Old_22M10],
	[CS_SumWinloss_Old_22M11],
	[CS_SumWinloss_Old_22M12],

	[CS_SumWinloss_Old_MAX]
 )                
GO
---
 
 


CREATE TABLE [dbo].[CS_SumWinloss_Old](
	CustID			Int
	,WinlostDate		Smalldatetime
	,ProductId		smallint
	,Sporttype		smallint
	,Bettype			smallint
	,IsLive			bit
	,Wagers			int
	,Stake			Money
	,ValidStake		Money
	,MemberWinloss	Money
	,MemberComm		Money
	,Agent			Money
	,AgentWinloss	Money
	,AgentComm		Money
	,AgentStock		Money
	,AgentResultA	Money
	,Master			Money
	,MasterWinloss	Money
	,MasterComm		Money
	,MasterStock	Money
	,Super			Money
	,SuperWinloss	Money
	,SuperComm		Money
	,SuperStock		Money
	,HeadlineWinloss	Money
	,HeadlineComm	Money
	,HeadlineStock	Money
	,HeadlineId		int
	)
 ON ps_CS_SumWinloss_Old_monthly (WinlostDate)
GO 

 GRANT SELECt ON [CS_SumWinloss_Old] TO bodbDownlineNet
GO 

GRANT SELECt ON [CS_SumWinloss_Old] TO bodbDownlineNetView
GO 

