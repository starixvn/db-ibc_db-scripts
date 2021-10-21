 /*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Create : 20211021@Danny 
	Regen data for AGCasino - [Redmine: #162947] 
	DB: DBACC.bodb02
*/

USE bodb02

-- DBACC - bodb02
-- resum data from bettrans_AGCasino to bettrans_AGCasino
DECLARE @__MinWLDate DATETIME = '2021-10-01'
DECLARE @__MaxWLDate DATETIME = '2021-10-20' 
DECLARE @__RunWLDate DATETIME

SELECT @__RunWLDate = @__MinWLDate


WHILE @__RunWLDate <= @__MaxWLDate
BEGIN
	PRINT('run: ' + CAST (@__RunWLDate  AS VARCHAR(20)))
	EXEC bodb02.dbo.Task_DOT_AGCasino_DailySummary @winlostdate = @__RunWLDate, @IsManual = 1
	SELECT @__RunWLDate = DATEADD(DAY, 1, @__RunWLDate )
END
	