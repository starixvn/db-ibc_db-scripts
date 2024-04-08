/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20240402@Lewis
	DB: DBCUST-CustDB
	Task : Support new currency SBC & DIV (Update code currency: USD -> SBC - ExchangeId = 213 || CNY -> DIV - ExchangeId = 214)
		   [RedmineID: #202273] + [RedmineID: #203096]
*/
USE CustDB

--SELECT * 
UPDATE EDO SET EDO.Code = 'SBC'
FROM ExchangeDailyOanda EDO WITH (ROWLOCK, UPDLOCK)
WHERE ExchangeId = 213

--SELECT * 
UPDATE EDO SET EDO.Code = 'DIV'
FROM ExchangeDailyOanda EDO WITH (ROWLOCK, UPDLOCK)
WHERE ExchangeId = 214

--SELECT * 
UPDATE E SET E.Code = 'SBC' , E.MultipliedBy = 1 , E.RepUpdateTime = SYSDATETIME()
FROM exchange E WITH (ROWLOCK, UPDLOCK)
WHERE ExchangeId = 213

--SELECT * 
UPDATE E SET E.Code = 'DIV' , E.MultipliedBy = 1 , E.RepUpdateTime = SYSDATETIME()
FROM exchange E WITH (ROWLOCK, UPDLOCK)
WHERE ExchangeId = 214
