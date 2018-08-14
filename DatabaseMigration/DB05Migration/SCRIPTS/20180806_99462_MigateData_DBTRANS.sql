/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DBTRANS/bodb02
	
	Acc_ExchangeRate: 239
	Acc_ExchangeRate_History: 282
	Acc_ExchangeRate_InvalidTransfer: 27030
	
*/
USE bodb02
GO
TRUNCATE TABLE Acc_ExchangeRate
GO
TRUNCATE TABLE Acc_ExchangeRate_History
GO
TRUNCATE TABLE Acc_ExchangeRate_InvalidTransfer
GO
INSERT INTO Acc_ExchangeRate (FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate, Creator, LastUpdate)
SELECT FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate, Creator, LastUpdate 
FROM DBPOLICY.BODB02.dbo.Acc_ExchangeRate WITH (NOLOCK)

GO
SET IDENTITY_INSERT Acc_ExchangeRate_History ON

INSERT INTO Acc_ExchangeRate_History (RowID, ActionDate, ActionType, UserID, FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate)
SELECT RowID, ActionDate, ActionType, UserID, FromExchangeID, ToExchangeID, MinActualRate, MaxActualRate
FROM DBPOLICY.BODB02.dbo.Acc_ExchangeRate_History WITH (NOLOCK)

SET IDENTITY_INSERT Acc_ExchangeRate_History OFF
GO

SET IDENTITY_INSERT Acc_ExchangeRate_InvalidTransfer ON

INSERT INTO Acc_ExchangeRate_InvalidTransfer (ID, TransDate, UserID, FromCust, ToCust, FromExchangeID, ToExchangeID, Rate, MinExRate, MaxExRate, ExRate, Amount, RefNo, IsDeleted)
SELECT ID, TransDate, UserID, FromCust, ToCust, FromExchangeID, ToExchangeID, Rate, MinExRate, MaxExRate, ExRate, Amount, RefNo, IsDeleted
FROM DBPOLICY.BODB02.dbo.Acc_ExchangeRate_InvalidTransfer WITH (NOLOCK)

SET IDENTITY_INSERT Acc_ExchangeRate_InvalidTransfer OFF
