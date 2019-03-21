USE [bodb_Summary]
GO

/*
Create: 20190320@Sophia
Task:  Structure CS_SumCancelled - CN88 [redmind: 105660]

*/
 
----------------2. [CS_SumCancelled]


ALTER DATABASE bodb_Summary ADD filegroup [CS_SumCancelled]

ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumCancelled', filename ='D:\IBC_DB\bodb_Summary\CS_SumCancelled\CS_SumCancelled.ndf', 
SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumCancelled]
 
 
  
CREATE TABLE [dbo].[CS_SumCancelled](
	CustID			Int
	,WinlostDate	Smalldatetime
	,ProductId		smallint
	,Sporttype		smallint
	,Bettype		smallint
	,IsLive			bit
	,CancelType     TINYINT
	,Wagers			int
	,Stake			Money
	,HeadlineId		int
)
ON [CS_SumCancelled]
GO 

 
CREATE CLUSTERED INDEX [CIX_CS_SumCancelled] ON [dbo].[CS_SumCancelled]
(
	CustID ASC,
	WinlostDate ASC,				
	Sporttype ASC,
	Bettype ASC,
	IsLive ASC
) ON [CS_SumCancelled]
GO
 

GRANT SELECt ON [CS_SumCancelled] TO bodbDownlineNetView
GO

GRANT SELECt ON [CS_SumCancelled] TO bodbDownlineNet
GO

