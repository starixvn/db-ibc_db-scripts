/*<info serverAlias="DBN88-bodb_N88" isFunction="0" isNested=""></info>*/
/*
Created: 20200716@Sol
Task: Re - Generate data for past months [Redmine: #137064]
DB: DBN88-bodb_N88
*/

USE bodb_N88

GO 

TRUNCATE TABLE N88_RptWinloss

GO

DECLARE @s DATE 
DECLARE cur CURSOR FOR 
SELECT DISTINCT CAST(DATEADD(hh, -4, SettledTime) AS DATE)
FROM dbo.TpBetRecord WITH(NOLOCK)
ORDER BY CAST(DATEADD(hh, -4, SettledTime) AS DATE)
OPEN cur 

FETCH NEXT FROM cur INTO @s

WHILE @@FETCH_STATUS = 0
BEGIN

	PRINT @s
	EXEC dbo.Task_N88_RptWinloss @WinlostDate = @s

	FETCH NEXT FROM cur INTO @s

END

CLOSE cur;  
DEALLOCATE cur; 

GO