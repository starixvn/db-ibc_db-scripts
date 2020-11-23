/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Create: 20201123@Danny
	DB : DBPRO-bodb02
	Task: Update product orderNo [redmine: #141832]
*/


DELETE t
FROM  dbo.Products t WITH(ROWLOCK) WHERE ProductID = 29

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

					 ---------------------------------------------------------------
						--WHEN t.ProductID = 1 THEN 10
						--WHEN t.ProductID = 3 THEN 30
						--WHEN t.ProductID = 5 THEN 100
						--WHEN t.ProductID = 6 THEN 210
						--WHEN t.ProductID = 8 THEN 70
						--WHEN t.ProductID = 11 THEN 180
						--WHEN t.ProductID = 12 THEN 150
						--WHEN t.ProductID = 14 THEN 230
						--WHEN t.ProductID = 16 THEN 12
						--WHEN t.ProductID = 21 THEN 130
						--WHEN t.ProductID = 22 THEN 200
						--WHEN t.ProductID = 23 THEN 40
						--WHEN t.ProductID = 24 THEN 110
						--WHEN t.ProductID = 28 THEN 60
						--WHEN t.ProductID = 32 THEN 250
						--WHEN t.ProductID = 34 THEN 220
						--WHEN t.ProductID = 36 THEN 240
						--WHEN t.ProductID = 37 THEN 20
						--WHEN t.ProductID = 38 THEN 90
						--WHEN t.ProductID = 39 THEN 160
						--WHEN t.ProductID = 40 THEN 80
						--WHEN t.ProductID = 42 THEN 120
						--WHEN t.ProductID = 43 THEN 50
						--WHEN t.ProductID = 45 THEN 170
						--WHEN t.ProductID = 46 THEN 190
						--WHEN t.ProductID = 47 THEN 140
						--WHEN t.ProductID = 50 THEN 75
						--WHEN t.ProductID = 51 THEN 194
						--WHEN t.ProductID = 52 THEN 192
						--WHEN t.ProductID = 55 THEN 260
						--WHEN t.ProductID = 56 THEN 270
					 -- -----------------------------------------------------------
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

