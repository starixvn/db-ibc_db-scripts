/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20240402@Lewis
	DB: DBCUST-CustDB
	Task : DIV => DIA
		  (Update code currency: CNY -> DIA - ExchangeId = 214)
		  [RedmineID: #203096]
*/
USE CustDB

--SELECT * 
UPDATE EDO SET EDO.Code = 'DIA'
FROM ExchangeDailyOanda EDO WITH (ROWLOCK, UPDLOCK)
WHERE ExchangeId = 214


--SELECT * 
UPDATE E SET E.Code = 'DIA' , E.Currency = 'DIA' , E.Description = 'PKKing, 1CNY=8DIA' , E.RepUpdateTime = SYSDATETIME()
FROM exchange E WITH (ROWLOCK, UPDLOCK)
WHERE ExchangeId = 214
