/*
	Created by: Winnie
	Date: 2016-10-24
	Task: insert data in ProductBetSetting for Max Keno 2 [Redmine:#66058]	
*/ 

----------------------------------------------------------------
--Insert data into DBCUST.CustDB.dbo.ProductBetSetting-----------
----------------------------------------------------------------
USE CustDB
GO

INSERT INTO ProductBetSetting (Sporttype, Bettype, Currency, MinBet, IsDep) 
SELECT Sporttype, 1516, Currency, MinBet, IsDep
from ProductBetSetting(NOLOCK)  where Sporttype=202 and Bettype=1515

----------------------------------------------------------------
--Update data DBTXN.bodb02.dbo.GameType-------------------------
----------------------------------------------------------------
USE bodb02 
GO
INSERT INTO [bodb02].[dbo].[GameType]
           ([GameTypeID]
           ,[GameTypeName]
           ,[IsDisabled]
           ,[IBCBetTypeID])
     VALUES
           (16,
           'Max Keno 2'
           ,0
           ,1516)
GO

