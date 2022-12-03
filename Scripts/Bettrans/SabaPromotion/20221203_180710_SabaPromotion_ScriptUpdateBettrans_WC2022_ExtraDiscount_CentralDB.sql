/*<info serverAlias="DBCTG-bodb02"></info>*/
/*
	Created: 20221203@Sophia
	DB : DBCTG-bodb02
	Task: Insert bet ticket Saba Promotion - bettype 17005 - Extra discount WC 2022 [Redmine: #180710]
*/
USE bodb02
GO 
 
update bettrans WITH (ROWLOCK)
SET actualrate = 4.47433185577393 
Where TransID = 57633839735898257
and winlostdate = '2022-11-30'


/*
ActualRate 				ExchangeDate
4.47433185577393	2022-11-30 00:00:00
4.40754985809326	2022-12-01 00:00:00
4.39665269851685	2022-12-02 00:00:00
4.38773536682129	2022-12-03 00:00:00
4.38773536682129	2022-12-04 00:00:00


*/