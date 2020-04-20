USE bodb_Archive
GO 

/*
	Create: 20200418@Sophia
	DB: DBARC.bodb_Archive
	Task: regen data TurnoverNoDraw for sexy gaming, SA gaming - Sum_Winloss_old [Redmine: #132695]
*/

DECLARE @MBU AS TABLE (BalanceUpDay SMALLDATETIME, MovebetsDay SMALLDATETIME)
DECLARE @BalanceUpDay SMALLDATETIME, @MovebetsDay SMALLDATETIME, @Winlostdate SMALLDATETIME 

CREATE TABLE #SportBettype (ProductID INT, Bettype INT, SportType INT) 

INSERT INTO #SportBettype (ProductID, Bettype, SportType)
SELECT  ProductID, Bettype, SportType
FROM	bodb02.dbo.SportbettypeMatrix WITH (NOLOCK) WHERE ProductID IN (39, 45)   -- SA Gaming, Sexy Gaming 
 
CREATE TABLE Sum_Winloss_ARC 
(
winlostdate	datetime
,username	nvarchar(50)
,custid	int
,roleid	int
,recommend	int
,mrecommend	int
,srecommend	int
,turnover	money
,winlost	money
,awinlost	money
,mwinlost	money
,swinlost	money
,playercomm	money
,comm	money
,acomm	money
,scomm	money
,BetCount	int
,grosscomm	money
,sporttype	smallint
,bettype	smallint
,netTurnover	money
,TurnoverNoDraw	money )

  
INSERT INTO @MBU
EXEC bodb02.dbo.AGE_SelBalanceUpday

SELECT @BalanceUpDay = BalanceUpDay, @MovebetsDay = MovebetsDay
FROM @MBU

SELECT @Winlostdate = '2020-03-30' 

WHILE @Winlostdate <= @BalanceUpDay 
BEGIN 

		INSERT INTO Sum_Winloss_ARC
			(winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
			turnover, winlost, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm, betcount, grosscomm,
			sporttype, bettype, netTurnover, TurnoverNoDraw)

			SELECT @winlostdate, 1,
				customer.custid, customer.recommend, customer.mrecommend, customer.srecommend, customer.username,
				sum(ABS(stake)) TurnOver,
				sum(winlost-actual_stake)  winlost,
				sum(awinlost) awinlost,
				sum(mwinlost) mwinlost,
				sum(IsNull(swinlost,0)) swinlost,
				sum(playercomm) playercomm,
				sum(comm) comm,
				sum(acomm) acomm,
				sum(IsNull(scomm,0)) scomm,
				COUNT(1) BetCount,
				SUM(CASE WHEN apositiontaking = 1 THEN 0 ELSE ISNULL(comm/(1-apositiontaking),0) END) grosscomm, 
				CASE					
					WHEN Bettype BETWEEN 3001 AND 3099 THEN 244 -- SA Gaming
					WHEN Bettype BETWEEN 3101 AND 3199 THEN 243 -- Sexy Gaming
					ELSE 0 END sporttype,
				CASE WHEN bettype IN (71,72) THEN bettype ELSE 0 END bettype, 
				0 AS netTurnover,
				SUM( CASE	WHEN StatusID IN (112,113) AND MOdds IN (-0.25, 0.25) 
								---- Sportsbook
								AND (Bettype < 999 OR bettype BETWEEN 1301 AND 1399 OR bettype BETWEEN 9001 AND 9399)
								AND Bettype NOT IN (71,72)
								AND Bettype NOT BETWEEN 81 AND 120			
								THEN ABS(stake)/2
							WHEN StatusID = 111  
								AND (
									---- Sportsbook
										(Bettype < 999 OR bettype BETWEEN 1301 AND 1399 OR bettype BETWEEN 9001 AND 9399)
										AND Bettype NOT IN (71,72)
										AND Bettype NOT BETWEEN 81 AND 120
								)
								THEN 0
							WHEN   Bettype BETWEEN 3001 AND 3099   -- SA Gaming
								OR Bettype BETWEEN 3101 AND 3199   -- Sexy Gaming 
								THEN oddsspread
							ELSE ABS(stake) 
						END) AS TurnoverNoDraw
			FROM
				bodb02.dbo.customer with (nolock),
				dbo.Bettrans_BK bettrans with (nolock)
			WHERE
				bettrans.custid=customer.custid and 
				bettrans.winlostdate = @winlostdate and 
				bettrans.statusID NOT IN (0,1,102,101,103) and 				
				bettrans.Bettype IN (SELECT Bettype from #SportBettype)	 
		
			GROUP BY
				customer.custid, customer.recommend, customer.mrecommend, customer.srecommend,
				customer.username,
				CASE					 
					WHEN Bettype BETWEEN 3001 AND 3099 THEN 244 -- SA Gaming
					WHEN Bettype BETWEEN 3101 AND 3199 THEN 243 -- Sexy Gaming					 
					ELSE 0 END,
				CASE WHEN bettype IN (71,72) THEN bettype ELSE 0 END


		INSERT INTO Sum_Winloss_ARC
			(winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
			turnover, winlost, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm, betcount, grosscomm,
			sporttype, bettype, netTurnover, TurnoverNoDraw)
			SELECT @winlostdate, 2,
				ag.custid, customer.recommend, customer.mrecommend, customer.srecommend, ag.username,
				sum(ABS(stake)) TurnOver,
				sum(winlost-actual_stake)  winlost,
				sum(awinlost) awinlost,
				sum(mwinlost) mwinlost,
				sum(IsNull(swinlost,0)) swinlost,
				sum(playercomm) playercomm,
				sum(comm) comm,
				sum(acomm) acomm,
				sum(IsNull(scomm,0)) scomm,
				COUNT(1) BetCount,
				SUM(CASE WHEN apositiontaking+mpositiontaking = 1 THEN 0 ELSE ISNULL(acomm/(1-apositiontaking-mpositiontaking), 0) END) grosscomm, 
				CASE					 
					WHEN Bettype BETWEEN 3001 AND 3099 THEN 244 -- SA Gaming
					WHEN Bettype BETWEEN 3101 AND 3199 THEN 243 -- Sexy Gaming					 
					ELSE 0 END sporttype,
				CASE WHEN bettype IN (71,72) THEN bettype ELSE 0 END bettype,
				sum(ABS(stake*apositiontaking)) AS netTurnover,
				SUM( CASE	WHEN StatusID IN (112,113) AND MOdds IN (-0.25, 0.25) 
								---- Sportsbook
								AND (Bettype < 999 OR bettype BETWEEN 1301 AND 1399 OR bettype BETWEEN 9001 AND 9399)
								AND Bettype NOT IN (71,72)
								AND Bettype NOT BETWEEN 81 AND 120			
								THEN ABS(stake)/2
							WHEN StatusID = 111  
								AND (
									---- Sportsbook
										(Bettype < 999 OR bettype BETWEEN 1301 AND 1399 OR bettype BETWEEN 9001 AND 9399)
										AND Bettype NOT IN (71,72)
										AND Bettype NOT BETWEEN 81 AND 120
								)
								THEN 0
							WHEN   Bettype BETWEEN 3001 AND 3099   -- SA Gaming
								OR Bettype BETWEEN 3101 AND 3199   -- Sexy Gaming
								THEN oddsspread
							ELSE ABS(stake) 
						END) AS TurnoverNoDraw
			FROM
				bodb02.dbo.customer with (nolock),
				bodb02.dbo.customer ag with (nolock),
				dbo.Bettrans_BK bettrans with (nolock)
			WHERE
				bettrans.custid=customer.custid and 
				bettrans.winlostdate = @winlostdate and
				bettrans.statusID NOT IN (0,1,101,102,103) and 
				ag.custid=customer.recommend and customer.roleid=1 and ag.roleid=2 and				
				bettrans.Bettype IN (SELECT Bettype from #SportBettype)	 
			GROUP BY
				ag.custid, customer.recommend, customer.mrecommend, customer.srecommend,
				ag.username,
				CASE					 
					WHEN Bettype BETWEEN 3001 AND 3099 THEN 244 -- SA Gaming
					WHEN Bettype BETWEEN 3101 AND 3199 THEN 243 -- Sexy Gaming					
					ELSE 0 END,
				CASE WHEN bettype IN (71,72) THEN bettype ELSE 0 END


		INSERT INTO Sum_Winloss_ARC
			(winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
			turnover, winlost, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm, betcount, grosscomm,
			sporttype, bettype, netTurnover, TurnoverNoDraw)
			SELECT @winlostdate, 3,
				ma.custid, 0 recommend, customer.mrecommend, customer.srecommend, ma.username,
				sum(ABS(stake)) TurnOver,
				sum(winlost-actual_stake)  winlost,
				sum(awinlost) awinlost,
				sum(mwinlost) mwinlost,
				sum(IsNull(swinlost,0)) swinlost,
				sum(playercomm) playercomm,
				sum(comm) comm,
				sum(acomm) acomm,
				sum(IsNull(scomm,0)) scomm,
				COUNT(1) BetCount,
				SUM(CASE WHEN tpositiontaking = 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) grosscomm,
				CASE					
					WHEN Bettype BETWEEN 3001 AND 3099 THEN 244 -- SA Gaming
					WHEN Bettype BETWEEN 3101 AND 3199 THEN 243 -- Sexy Gaming
					ELSE 0 END sporttype,
				CASE WHEN bettype IN (71,72) THEN bettype ELSE 0 END bettype,
				sum(ABS(stake*mpositiontaking)) AS netTurnover,
				SUM( CASE	WHEN StatusID IN (112,113) AND MOdds IN (-0.25, 0.25) 
								---- Sportsbook
								AND (Bettype < 999 OR bettype BETWEEN 1301 AND 1399 OR bettype BETWEEN 9001 AND 9399)
								AND Bettype NOT IN (71,72)
								AND Bettype NOT BETWEEN 81 AND 120			
								THEN ABS(stake)/2
							WHEN StatusID = 111  
								AND (
									---- Sportsbook
										(Bettype < 999 OR bettype BETWEEN 1301 AND 1399 OR bettype BETWEEN 9001 AND 9399)
										AND Bettype NOT IN (71,72)
										AND Bettype NOT BETWEEN 81 AND 120
								)
								THEN 0
							WHEN  Bettype BETWEEN 3001 AND 3099   -- SA Gaming
								OR Bettype BETWEEN 3101 AND 3199   -- Sexy Gaming
								THEN oddsspread
							ELSE ABS(stake) 
						END) AS TurnoverNoDraw
			FROM
				bodb02.dbo.customer with (nolock),
				bodb02.dbo.customer ma with (nolock),
				dbo.Bettrans_BK bettrans with (nolock)
			WHERE
				bettrans.custid=customer.custid and 
				bettrans.winlostdate = @winlostdate and
				bettrans.statusID NOT IN (0,1,101,102,103) and
				ma.custid=customer.mrecommend and customer.roleid=1 and ma.roleid=3 and				
				bettrans.Bettype IN (SELECT Bettype from #SportBettype)	 
			GROUP BY
				ma.custid, customer.mrecommend, customer.srecommend, 
				ma.username,
				CASE					
					WHEN Bettype BETWEEN 3001 AND 3099 THEN 244 -- SA Gaming
					WHEN Bettype BETWEEN 3101 AND 3199 THEN 243 -- Sexy Gaming
					ELSE 0 END,
				CASE WHEN bettype IN (71,72) THEN bettype ELSE 0 END
				 
		INSERT INTO Sum_Winloss_ARC
			(winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
			turnover, winlost, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm, betcount, grosscomm,
			sporttype, bettype, netTurnover, TurnoverNoDraw)
			SELECT @winlostdate, 4,
				sa.custid, 0 recommend, 0 mrecommend, customer.srecommend, sa.username,
				sum(ABS(stake))  TurnOver,
				sum(winlost-actual_stake)  winlost,
				sum(awinlost) awinlost,
				sum(mwinlost) mwinlost,
				sum(IsNull(swinlost,0)) swinlost,
				sum(playercomm) playercomm,
				sum(comm) comm,
				sum(acomm) acomm,
				sum(IsNull(scomm,0)) scomm,
				COUNT(1) BetCount,
				SUM(CASE WHEN tpositiontaking = 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) grosscomm,
				CASE					
					WHEN Bettype BETWEEN 3001 AND 3099 THEN 244 -- SA Gaming
					WHEN Bettype BETWEEN 3101 AND 3199 THEN 243 -- Sexy Gaming					
					ELSE 0 END sporttype,
				CASE WHEN bettype IN (71,72) THEN bettype ELSE 0 END bettype,
				sum(ABS(stake*spositiontaking)) AS netTurnover,
				SUM( CASE	WHEN StatusID IN (112,113) AND MOdds IN (-0.25, 0.25) 
								---- Sportsbook
								AND (Bettype < 999 OR bettype BETWEEN 1301 AND 1399 OR bettype BETWEEN 9001 AND 9399)
								AND Bettype NOT IN (71,72)
								AND Bettype NOT BETWEEN 81 AND 120			
								THEN ABS(stake)/2
							WHEN StatusID = 111  
								AND (
									---- Sportsbook
										(Bettype < 999 OR bettype BETWEEN 1301 AND 1399 OR bettype BETWEEN 9001 AND 9399)
										AND Bettype NOT IN (71,72)
										AND Bettype NOT BETWEEN 81 AND 120
								)
								THEN 0
							WHEN   Bettype BETWEEN 3001 AND 3099   -- SA Gaming
								OR Bettype BETWEEN 3101 AND 3199   -- Sexy Gaming								
								THEN oddsspread
							ELSE ABS(stake) 
						END) AS TurnoverNoDraw
			FROM
				bodb02.dbo.customer with (nolock),
				bodb02.dbo.customer sa with (nolock),
				dbo.Bettrans_BK bettrans with (nolock)
			WHERE
				bettrans.custid=customer.custid and 
				bettrans.winlostdate = @winlostdate and
				bettrans.statusID NOT IN (0,1,101,102,103) and
				sa.custid=customer.srecommend and customer.roleid=1 and sa.roleid=4 and				
				bettrans.Bettype IN (SELECT Bettype from #SportBettype)	 
			GROUP BY
				sa.custid, customer.srecommend, 
				sa.username,
				CASE					
					WHEN Bettype BETWEEN 3001 AND 3099 THEN 244 -- SA Gaming
					WHEN Bettype BETWEEN 3101 AND 3199 THEN 243 -- Sexy Gaming
					ELSE 0 END,
				CASE WHEN bettype IN (71,72) THEN bettype ELSE 0 END



		SELECT @Winlostdate  = DATEADD( DAY, 1, @Winlostdate)
	END
	


DROP TABLE #SportBettype 
	

 
 ------------II. Update Sum_Winloss_Old-------------
/*
DB: DBSUM.bodb_Summary
*/

USE bodb_Summary 
GO 


CREATE TABLE #Sum_Winloss_ARC 
(
winlostdate	datetime
,username	nvarchar(50)
,custid	int
,roleid	int
,recommend	int
,mrecommend	int
,srecommend	int
,turnover	money
,winlost	money
,awinlost	money
,mwinlost	money
,swinlost	money
,playercomm	money
,comm	money
,acomm	money
,scomm	money
,BetCount	int
,grosscomm	money
,sporttype	smallint
,bettype	smallint
,netTurnover	money
,TurnoverNoDraw	money )
 

 INSERT INTO #Sum_Winloss_ARC
 SELECT * FROM DBARC.bodb_Archive.dbo.Sum_Winloss_ARC


  UPDATE s
  SET s.TunroverNoDraw = t.TurnoverNoDraw
  FROM dbo.Sum_Winloss_old s WITH (ROWLOCK)
  INNER JOIN #Sum_Winloss_ARC t 
	ON t.winlostdate = s.winlostdate
	AND t.srecommend = s.srecommend
	AND t.mrecommend = s.mrecommend
	AND t.recommend = s.recommend
	AND t.CustID = s.CustID
	AND t.roleid = s.roleid
	AND t.sporttype = s.sporttype
	AND t.bettype = s.bettype 

	
DROP TABLE #Sum_Winloss_ARC 

------------------------------------
/*
	DB: DBARC.bodb_Archive
*/


 DROP TABLE Sum_Winloss_ARC 

 