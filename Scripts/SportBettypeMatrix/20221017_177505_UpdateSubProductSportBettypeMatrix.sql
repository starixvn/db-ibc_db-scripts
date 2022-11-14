/*<info serverAlias="DBPRO-bodb02"></info>*/

/*
	Created: 20221017@Danny
	DB: DBPRO-bodb02
	Task: Update SubProduct [RedmineId : #177505]

	Description: intend remove hardcode in SP so get value from SportBettypeMatrix table

*/
UPDATE bodb02.dbo.SportBettypeMatrix with(ROWLOCK, UPDLOCK)
SET SubProduct = CASE WHEN bettype = 1698 THEN 'Jackpot Contribution'
						WHEN bettype = 1699 THEN 'Jackpot Prize'
						WHEN bettype = 1906 THEN 'Bonus'
						WHEN bettype = 3898 THEN 'Jackpot Contribution'
						WHEN bettype = 3899 THEN 'Jackpot Prize'
						WHEN bettype = 2499 THEN 'Promotion'
						WHEN bettype = 3150 THEN 'Lucky Draw'
						WHEN bettype = 3007 THEN 'Tips'
						WHEN bettype = 4599 THEN 'Jackpot Contribution'
						WHEN bettype = 4600 THEN 'Jackpot Prize'
						WHEN bettype = 4297 THEN 'Jackpot Contribution'
						WHEN bettype = 4298 THEN 'Jackpot Prize'
						WHEN bettype = 4299 THEN 'Prize'
						WHEN bettype = 4300 THEN 'Prize'
						WHEN bettype = 1706 THEN 'Tips'
						END
WHERE  bettype in (1706,3007,4297,1698,3898,4599,4298,1699,3899,4600,4299,4300,3150,1906,2499)
