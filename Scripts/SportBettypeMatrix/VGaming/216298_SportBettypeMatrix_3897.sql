/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created by: Lewis@20250102
	Task: Update SubProduct - VGaming PromotionPrize [Redmine:#216298] 
	DB:	DBPRO-bodb02
*/

--SELECT *
UPDATE S WITH (ROWLOCK,UPDLOCK) SET S.SubProduct = 'Prize'
FROM SportBettypeMatrix S
WHERE BetType = 3897