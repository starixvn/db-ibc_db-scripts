/*<info serverAlias="DBN88-bodb_N88" isFunction="0" isNested="0"></info>*/
/*
	Created: 20230509@Evan
	DB: DBN88-bodb_N88
	Task: Re sum missing ticket V8 Poker
	Step 1: Gen data into N88_RptWinloss
*/
USE bodb_N88;
DECLARE @WinlostDate SMALLDATETIME;

SELECT @WinlostDate = '20230427'

EXEC Task_N88_SumWinloss @WinlostDate = @WinlostDate
