  /*
	Created: 20160805Winnie
	Task : Bettrade Apply new business terms
	DB: DBCust/CustDB		
*/

Use CustDB
GO

ALTER TABLE BetTradeComm ADD HouseDeductionRate DECIMAL(9,8)
ALTER TABLE BetTradeComm ADD HousePT  SMALLMONEY

GO
