
Use bodb_Summary
GO

/*
Create: 20190321@Sophia
Task: DN88 table sum CS_SumCancelled_Old  - 110591
DB: DBSUM.bodb_Summary (DB052,DB053)
*/ 
 
--1
--Create files and file groups
ALTER DATABASE bodb_Summary ADD filegroup [CS_SumCancelled_Old] 
 
ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumCancelled_Old', filename ='D:\IBC_DB\bodb_Summary\CS_SumCancelled_Old\CS_SumCancelled_Old.ndf', SIZE = 1 MB ,FILEGROWTH = 16 MB ) 
TO filegroup [CS_SumCancelled_Old]
  
 

CREATE TABLE [dbo].[CS_SumCancelled_Old](
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
 ON [CS_SumCancelled_Old] 
GO 

GRANT SELECt ON [CS_SumCancelled_Old] TO bodbDownlineNet
GO 

GRANT SELECt ON [CS_SumCancelled_Old] TO bodbDownlineNetView
GO 


CREATE CLUSTERED INDEX [CIX_CS_SumCancelled_Old] ON [dbo].[CS_SumCancelled_Old]
(
	CustID ASC,
	WinlostDate ASC,				
	Sporttype ASC,
	Bettype ASC,
	IsLive ASC
) ON [CS_SumCancelled_Old]
GO