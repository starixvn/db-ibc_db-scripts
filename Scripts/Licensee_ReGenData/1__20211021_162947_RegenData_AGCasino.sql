 /*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Create : 20211021@Danny 
	Regen data for AGCasino - [Redmine: #162947] 
	DB: DBACC.bodb02
*/

USE bodb02

-- DBACC - bodb02
-- resum data from bettrans_AGCasino to bettrans_AGCasino
DECLARE @__RunWLDate DATETIME = '2021-10-12' 

EXEC bodb02.dbo.Task_DOT_AGCasino_DailySummary @winlostdate = @__RunWLDate, @IsManual = 1

	