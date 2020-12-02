/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Create: 20201123@Danny
	DB : DBPRO-bodb02
	Task: Update product orderNo [redmine: #141832]
*/


UPDATE t 
SET t.OrderNo = CASE WHEN t.ProductID = 31 THEN 14 -- Exchange
					 WHEN t.ProductID = 25 THEN 16 -- Cash Out
					 WHEN t.ProductID = 27 THEN 102 -- Virtual Sports 2
					 WHEN t.ProductID = 49 THEN 104 -- Virtual Sports 3
					 ---------------------------------------------------------
					 WHEN t.ProductID = 20 THEN 500 -- Cricket
					 WHEN t.ProductID = 41 THEN 505 -- Live Casino
					 WHEN t.ProductID = 44 THEN 510 -- RNG Lottery
					 WHEN t.ProductID = 53 THEN 515 -- RNG Casino
					 WHEN t.ProductID = 54 THEN 520 -- Saba Virtual Sports
					 ----------------------------------------------------------
					 WHEN t.ProductID = 2 THEN 600 -- Racing
					 WHEN t.ProductID = 4 THEN 602 -- SLI Live Casino
					 WHEN t.ProductID = 7 THEN 604 -- Bingo
					 WHEN t.ProductID = 9 THEN 606 -- P2P
					 WHEN t.ProductID = 10 THEN 608 -- Playtech Casino
					 WHEN t.ProductID = 13 THEN 610 -- Microgaming - Live Casino
					 WHEN t.ProductID = 15 THEN 612 -- Colossus Bets
					 WHEN t.ProductID = 17 THEN 614 -- Microgaming - RNG Casino
					 WHEN t.ProductID = 19 THEN 616 -- Cockfighting
					 WHEN t.ProductID = 26 THEN 618 -- Lucky 3
					 WHEN t.ProductID = 30 THEN 620 -- Bullfighting
					 WHEN t.ProductID = 33 THEN 622 -- Poker Games

					END
FROM dbo.Products t WITH(ROWLOCK)
WHERE t.ProductID IN  (	31 , -- Exchange
						25 , -- Cash Out
						27 , -- Virtual Sports 2
						49 , -- Virtual Sports 3
					 ---------------------------------------------------------
						20 , -- Cricket
						41 , -- Live Casino
						44 , -- RNG Lottery
						53 , -- RNG Casino
						54 , -- Saba Virtual Sports
					 ----------------------------------------------------------
						2 , -- Racing
						4 , -- SLI Live Casino
						7 , -- Bingo
						9 , -- P2P
						10 , -- Playtech Casino
						13 , -- Microgaming - Live Casino
						15 , -- Colossus Bets
						17 , -- Microgaming - RNG Casino
						19 , -- Cockfighting
						26 , -- Lucky 3
						30 , -- Bullfighting
						33 -- Poker Games
)

