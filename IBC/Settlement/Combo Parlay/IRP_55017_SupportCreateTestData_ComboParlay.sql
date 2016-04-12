USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[DBA_ComboParlayIns]    Script Date: 04/12/2016 14:19:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DBA_ComboParlayIns] 
	@custid				INT
	,@numberofmatch		INT = 3
	,@matchIdInfo		VARCHAR(1000)     -- Match ID list
	,@oddValueInfo		VARCHAR(1000)    -- Odd's value list
	,@betTeamInfo		VARCHAR(1000)  = 'h,a,h'  -- Betted team list
	,@betTypeInfo		VARCHAR(1000)  = '1,2,3'  -- bettype list
	,@apt				SMALLMONEY = 0
	,@mpt				SMALLMONEY = 0
	,@spt				SMALLMONEY = 0
	,@playerdc			DECIMAL(9,8) = 0
	,@dc				DECIMAL(9,8) = 0
	,@adc 				DECIMAL(9,8) = 0
	,@sdc 				DECIMAL(9,8) = 0
	
	,@Double			MONEY = 0
	,@Trebles			Money = 0
	,@4fold 			MONEY = 0
	,@5fold 			MONEY = 0
	,@6fold 			MONEY = 0
	,@7fold 			MONEY = 0
	,@8fold 			MONEY = 0
	,@9fold 			MONEY = 0
	,@10fold 			MONEY = 0
	,@11fold 			MONEY = 0
	,@12fold 			MONEY = 0
	,@13fold 			MONEY = 0
	,@14fold 			MONEY = 0
	,@15fold 			MONEY = 0
	,@16fold 			MONEY = 0
	,@17fold 			MONEY = 0
	,@18fold 			MONEY = 0
	,@19fold 			MONEY = 0
	,@20fold 			MONEY = 0
	
	,@fullsystemparlay	MONEY = 0
	,@Lucky				MONEY = 0
	
	,@mixparlay			MONEY = 0 -- For mixparlay (>20 matches)
AS
/*
	Created: 20160412@Kathy:
	Task: Support to create combo ticket on local [Redmine:#55017]
*/
BEGIN
	SET NOCOUNT ON
	
	IF @numberofmatch < 2
	BEGIN
		SELECT 'number of match should be >=2'
		
		RETURN
	END
	
	IF EXISTS (SELECT TOP 1 1 FROM dbo.strSplit(@oddValueInfo, ',') WHERE val < CAST(1 AS MONEY))
	BEGIN
		SELECT 'enter odds value >1'
		
		RETURN
	END
	
	DECLARE @matchinfo TABLE (id INT IDENTITY(1,1), matchorder INT, matchid int, eventdate SMALLDATETIME, sporttype SMALLINT)

	DECLARE @tblBettransmCombo TABLE (transid BIGINT)
	DECLARE @tblBettransmFullSP TABLE (transid BIGINT)
	DECLARE @tblBettransmLucky TABLE (transid BIGINT)
	DECLARE @tblBettransmMixParlay TABLE (transid BIGINT)
	
	DECLARE @tblBettransCombo TABLE (transid BIGINT, refno BIGINT)
	DECLARE @tblBettransFullSP TABLE (transid BIGINT, refno BIGINT)
	DECLARE @tblBettransLucky TABLE (transid BIGINT, refno BIGINT)
	DECLARE @tblBettransMixParlay TABLE (transid BIGINT, refno BIGINT)
	
	DECLARE @tblBettransSingleLucky TABLE (transid BIGINT)
	
	INSERT INTO @matchinfo(matchorder, matchid, eventdate, sporttype)
	SELECT TOP (@numberofmatch)ROW_NUMBER() OVER(ORDER BY m.matchid) AS seq, m.matchid, m.eventdate, m.sporttype
	FROM	dbo.strSplit(@matchIdInfo, ',') s
		INNER JOIN match m WITH(NOLOCK)
			ON s.val = m.matchid
			
	SET @numberofmatch = @@rowcount
	
	DECLARE	@matchbitmap VARCHAR(20) = REPLICATE('1',@numberofmatch)
			,@refno		BIGINT
			,@refn		INT
			,@betcheck	NVARCHAR(50)
			,@betteam	NVARCHAR(10)
			,@tpt		SMALLMONEY = 1 - @apt - @mpt - @spt
			,@bitmapcombo	VARCHAR(20) = REPLICATE('0',20)
			,@bitmapfullSP	VARCHAR(20) = REPLICATE('0',20)
			,@bitmapLucky	VARCHAR(20) = REPLICATE('0',20)
			,@bitmapMixparlay	VARCHAR(100) = '1' + REPLICATE('0',@numberofmatch - 1)
			,@stakescombo	VARCHAR(MAX) = '0'
			,@stakefullSP	MONEY
			,@stakelucky	MONEY
			,@numberofselection int = 0
			
			,@username VARCHAR(50)
			,@currency TINYINT
			,@currencyName NVARCHAR(50)
			,@recommend INT
			,@mrecommend INT
			,@srecommend INT
			,@mainStakeCombo MONEY = 0
			,@mainStakefullSP MONEY = 0
			,@mainStakeLucky MONEY = 0
			,@mainOdds MONEY
	
	SELECT	@mainOdds = CAST(EXP(SUM(CAST(LOG(val)AS DECIMAL(38, 20)))) as money)
	FROM	dbo.strSplit(@oddValueInfo,',')
	
	INSERT INTO odds(matchid, bettype,liveindicator, oddsstatus, sporttype)
	SELECT	m.matchid, s.val, 0, 'running', m.sporttype
	FROM	dbo.strSplit( @betTypeInfo,',') s
		INNER JOIN @matchinfo m
			ON m.id = s.rank
	WHERE	s.val NOT IN (SELECT bettype FROM odds where liveindicator = 0 AND matchid = m.matchid)
	
	SELECT @username = ci.username
		,@recommend = ci.recommend
		,@mrecommend = ci.mrecommend
		,@srecommend = ci.srecommend
		,@currency = ci.currency
		,@CurrencyName = exchange.currency
	FROM custdb.dbo.custinfo AS ci WITH (NOLOCK)
		INNER JOIN custdb.dbo.exchange WITH (NOLOCK) ON ci.currency = exchange.exchangeid
	WHERE ci.custid = @custid		
		
	BEGIN
		IF @double > 0
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,19 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20), @double, 2)
			
			SET @mainStakeCombo = @double * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 2)* dbo.f_Factorial(2)))
			
		END
		ELSE
			SET @stakescombo = '0'
			
		IF @Trebles > 0
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,18 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20), @Trebles, 2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @Trebles * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 3)* dbo.f_Factorial(3)))
		END
		ELSE	
			SET @stakescombo = @stakescombo + ',' + '0'

		IF @4fold > 0 AND @numberofmatch >=4
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,17 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@4fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @4fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 4)* dbo.f_Factorial(4)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @5fold > 0 AND @numberofmatch >=5
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,16 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@5fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @5fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 5)* dbo.f_Factorial(5)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
			
		IF @6fold > 0 AND @numberofmatch >=6
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,15 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@6fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @6fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 6)* dbo.f_Factorial(6)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @7fold > 0 AND @numberofmatch >=7
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,14 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@7fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @7fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 7)* dbo.f_Factorial(7)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
			
		IF @8fold > 0 AND @numberofmatch >=8
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,13 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@8fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @8fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 8)* dbo.f_Factorial(8)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
			
		IF @9fold > 0 AND @numberofmatch >=9
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,12 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@9fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @9fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 9)* dbo.f_Factorial(9)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @10fold > 0 AND @numberofmatch >=10
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,11 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@10fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @10fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 10)* dbo.f_Factorial(10)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @11fold > 0 AND @numberofmatch >=11
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,10 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@11fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @11fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 11)* dbo.f_Factorial(11)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @12fold > 0 AND @numberofmatch >=12
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,9 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@12fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @12fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 12)* dbo.f_Factorial(12)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		 
		IF @13fold > 0 AND @numberofmatch >=13
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,8 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@13fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @13fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 13)* dbo.f_Factorial(13)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @14fold > 0 AND @numberofmatch >=14
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,7 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@14fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @14fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 14)* dbo.f_Factorial(14)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @15fold > 0 AND @numberofmatch >=15
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,6 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@15fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @15fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 15)* dbo.f_Factorial(15)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @16fold > 0 AND @numberofmatch >=16
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,5 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@16fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @16fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 16)* dbo.f_Factorial(16)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @17fold > 0 AND @numberofmatch >=17
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,4 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@17fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @17fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 17)* dbo.f_Factorial(17)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
		
		IF @18fold > 0 AND @numberofmatch >=18
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,3 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@18fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @18fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 18)* dbo.f_Factorial(18)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
			
		IF @19fold > 0 AND @numberofmatch >=19
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,2 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@19fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @19fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 19)* dbo.f_Factorial(19)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
			
		IF @20fold > 0 AND @numberofmatch =20
		BEGIN
			SET @bitmapcombo = stuff(@bitmapcombo,1 ,1,'1')
			SET @stakescombo = @stakescombo + ',' + CONVERT(VARCHAR(20),@20fold,2)
			
			SET @mainStakeCombo= @mainStakeCombo+ @20fold * (dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - 20)* dbo.f_Factorial(20)))
		END
		ELSE
			SET @stakescombo = @stakescombo + ',' + '0'
	END
	
	IF @fullsystemparlay > 0
	BEGIN
		SET @bitmapfullSP = STUFF(@bitmapfullSP,LEN(@bitmapfullSP) - @numberofmatch + 1, @numberofmatch - 1, REPLICATE('1',@numberofmatch-1))
		SET @stakefullSP = @fullsystemparlay
		SET @numberofselection = 0
		
		DECLARE @loopSP int = 2
		
		WHILE (@loopSP <= @numberofmatch)
		BEGIN
			IF SUBSTRING(@bitmapfullSP, len(@bitmapfullSP) - (@loopSP - 1), 1) = '1'
				SET @numberofselection = @numberofselection + dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - @loopSP) * dbo.f_Factorial(@loopSP))
				
			SET @loopSP = @loopSP + 1
		END

		SET @mainStakefullSP = @fullsystemparlay * @numberofselection

		
	END
	
	IF @Lucky > 0 
	BEGIN
		SET @bitmapLucky = STUFF(@bitmapLucky,LEN(@bitmapLucky) - @numberofmatch + 1, @numberofmatch, REPLICATE('1',@numberofmatch))
		SET @stakelucky = @lucky
		SET @numberofselection = 0
		
		DECLARE @loopLucky int = 2
		
		WHILE (@loopLucky <= @numberofmatch)
		BEGIN
			IF SUBSTRING(@bitmapLucky, len(@bitmapLucky) - (@loopLucky - 1), 1) = '1'
				SET @numberofselection = @numberofselection + dbo.f_Factorial(@numberofmatch) / (dbo.f_Factorial(@numberofmatch - @loopLucky) * dbo.f_Factorial(@loopLucky))
				
			SET @loopLucky = @loopLucky + 1
		END

		SET @mainStakeLucky = @lucky * @numberofselection		
	END
	
	IF @numberofmatch <=20
	BEGIN
		IF dbo.BinaryToDecimal(@bitmapcombo) > 0
		BEGIN
			--combo
			IF len(@bitmapcombo) - len(replace(@bitmapcombo,'1','')) >1
			BEGIN
				UPDATE ref with (rowlock,updlock) SET @refn=refno=refno+1  WHERE  refid='refno'
				set @refno = @refn + 100000000000
		
				INSERT INTO dbo.bettransm (custid, transdate, oddsid,  odds, stake, status, betteam, creator, refno, winlostdate, betfrom, apositiontaking, 
					mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount, matchid, matchdate, bettype, spositiontaking, sdiscount, statusID, comstatus)
				OUTPUT INSERTED.transid INTO @tblBettransmCombo (transid)
				SELECT @custid AS custid, GETDATE(),(SELECT top 1 oddsid FROM odds with(NOLOCK) WHERE matchid = m.matchid AND bettype = btype.val AND liveindicator = 0 ), o.val AS odds, s.val AS stake, 'running', bteam.val AS betteam, @custid AS creator, @refno AS refno, m.eventdate AS winlostdate, 'i' AS betfrom, @apt,
					@mpt, @tpt, @playerdc, @dc, @adc, m.matchid, m.eventdate, btype.val AS bettype, @spt, @sdc, 0 AS statusid, @refno
				FROM	@matchinfo m
					INNER JOIN dbo.strSplit(@oddValueInfo, ',') o
						ON m.id = o.rank
					INNER JOIN dbo.strSplit(@betTypeInfo, ',') btype
						ON o.rank = btype.rank
					INNER JOIN dbo.strSplit(@betTeamInfo,',') bteam
						ON btype.rank = bteam.rank		
					INNER JOIN dbo.strSplit(@stakescombo, ',') s
						ON s.rank = m.matchorder
						
				INSERT INTO dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, apositiontaking, mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount,
					betteam, creator, winlostdate, betfrom, betcheck, matchid, recommend, mrecommend, ruben, bettype, actual_stake, currency, sdiscount, spositiontaking, srecommend, 
					Username, CurrencyName, statusID, modds, refno, comstatus, oddstype, betid)
				OUTPUT INSERTED.transid, INSERTED.refno INTO @tblBettransCombo (transid, refno)
				SELECT @custid, GETDATE(), 1, 1 AS hdp1, @numberofmatch AS hdp2,  @mainOdds AS odds, @mainStakeCombo AS stake, 'running', @apt, @mpt, @tpt, @playerdc, @dc, @adc,
					 dbo.BinaryToDecimal(reverse(RIGHT(@bitmapcombo,@numberofmatch))) AS betteam, @custid AS creator, (SELECT MAX(eventdate) FROM @matchinfo) AS winlostdate, 'i' AS betfrom, dbo.BinaryToDecimal(@bitmapcombo) AS betcheck,
					 29 AS matchid, @recommend, @mrecommend, 0 AS ruben, 29 AS bettype, @mainStakeCombo AS actual_stake, @currency, @sdc, @spt, @srecommend, @username, @currencyname, 0 as statusid, 1	, @refno, 0, 1,0
			END
			ELSE
			BEGIN
				UPDATE ref with (rowlock,updlock) SET @refn=refno=refno+1  WHERE  refid='refno'
				set @refno = @refn + 100000000000
		
				-- just 1 combo
				INSERT INTO dbo.bettransm (custid, transdate, oddsid,  odds, stake, status, betteam, creator, refno, winlostdate, betfrom, apositiontaking, 
					mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount, matchid, matchdate, bettype, spositiontaking, sdiscount, statusID, comstatus)
				OUTPUT INSERTED.transid INTO @tblBettransmCombo (transid)
				SELECT @custid AS custid, GETDATE(), (SELECT top 1 oddsid FROM odds with(NOLOCK) WHERE matchid = m.matchid AND bettype = btype.val AND liveindicator = 0 ), o.val AS odds, (SELECT MAX(val) FROM dbo.strSplit(@stakescombo,',')) AS stake, 'running', bteam.val AS betteam, @custid AS creator, @refno AS refno, m.eventdate AS winlostdate, 'i' AS betfrom, @apt,
					@mpt, @tpt, @playerdc, @dc, @adc, m.matchid, m.eventdate, btype.val AS bettype, @spt, @sdc, 0 AS statusid, @refno					
				FROM	@matchinfo m
					INNER JOIN dbo.strSplit(@oddValueInfo, ',') o
						ON m.id = o.rank
					INNER JOIN dbo.strSplit(@betTypeInfo, ',') btype
						ON o.rank = btype.rank
					INNER JOIN dbo.strSplit(@betTeamInfo,',') bteam
						ON btype.rank = bteam.rank		
			
						
				-- bettrans
				INSERT INTO dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, apositiontaking, mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount,
					betteam, creator, winlostdate, betfrom, betcheck, matchid, recommend, mrecommend, ruben, bettype, actual_stake, currency, sdiscount, spositiontaking, srecommend, 
					Username, CurrencyName, statusID, modds, refno, comstatus, oddstype, betid)
				OUTPUT INSERTED.transid, INSERTED.refno INTO @tblBettransCombo (transid,refno)
				SELECT @custid, GETDATE(), 1, 1 AS hdp1, @numberofmatch AS hdp2,  @mainOdds AS odds, @mainStakeCombo AS stake, 'running', @apt, @mpt, @tpt, @playerdc, @dc, @adc,
					 dbo.BinaryToDecimal(reverse(RIGHT(@bitmapcombo,@numberofmatch))) AS betteam, @custid AS creator, (SELECT MAX(eventdate) FROM @matchinfo) AS winlostdate, 'i' AS betfrom, dbo.BinaryToDecimal(@bitmapcombo) AS betcheck,
					 29 AS matchid, @recommend, @mrecommend, 0 AS ruben, 29 AS bettype, @mainStakeCombo AS actual_stake, @currency, @sdc, @spt, @srecommend, @username, @currencyname, 0 as statusid, 1	, @refno, 0,1,0
			END
			
			SELECT 'bettransMCombo', * FROM @tblBettransmCombo
			SELECT 'bettransCombo', * FROM @tblBettransCombo
		END
		
		IF dbo.BinaryToDecimal(@bitmapfullSP) > 0 
		BEGIN
			UPDATE ref with (rowlock,updlock) SET @refn=refno=refno+1  WHERE  refid='refno'
			set @refno = @refn + 100000000000
			
			-- full System parlay
			INSERT INTO dbo.bettransm (custid, transdate, oddsid,  odds, stake, status, betteam, creator, refno, winlostdate, betfrom, apositiontaking, 
					mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount, matchid, matchdate, bettype, spositiontaking, sdiscount, statusID, comstatus)
			OUTPUT INSERTED.transid INTO @tblBettransmFullSP (transid)
			SELECT @custid AS custid, GETDATE(), (SELECT top 1 oddsid FROM odds with(NOLOCK) WHERE matchid = m.matchid AND bettype = btype.val AND liveindicator = 0 ), o.val AS odds, @stakefullSP AS stake, 'running', bteam.val AS betteam, @custid AS creator, @refno AS refno, m.eventdate AS winlostdate, 'i' AS betfrom, @apt,
				@mpt, @tpt, @playerdc, @dc, @adc, m.matchid, m.eventdate, btype.val AS bettype, @spt, @sdc, 0 AS statusid, @refno		
			FROM	@matchinfo m
				INNER JOIN dbo.strSplit(@oddValueInfo, ',') o
					ON m.id = o.rank
				INNER JOIN dbo.strSplit(@betTypeInfo, ',') btype
					ON o.rank = btype.rank
				INNER JOIN dbo.strSplit(@betTeamInfo,',') bteam
					ON btype.rank = bteam.rank	
				
					
			-- bettrans
			INSERT INTO dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, apositiontaking, mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount,
					betteam, creator, winlostdate, betfrom, betcheck, matchid, recommend, mrecommend, ruben, bettype, actual_stake, currency, sdiscount, spositiontaking, srecommend, 
					Username, CurrencyName, statusID, modds, refno, comstatus, oddstype, betid)
			OUTPUT INSERTED.transid, INSERTED.refno INTO @tblBettransFullSP (transid, refno)
			SELECT @custid, GETDATE(), 1, 0 AS hdp1, @numberofmatch AS hdp2,  @mainOdds AS odds, @mainStakefullSP AS stake, 'running', @apt, @mpt, @tpt, @playerdc, @dc, @adc,
				 dbo.BinaryToDecimal(reverse(RIGHT(@bitmapfullSP,@numberofmatch))) AS betteam, @custid AS creator, (SELECT MAX(eventdate) FROM @matchinfo) AS winlostdate, 'i' AS betfrom, dbo.BinaryToDecimal(@bitmapfullSP) AS betcheck,
				 29 AS matchid, @recommend, @mrecommend, 0 AS ruben, 29 AS bettype, @mainStakefullSP AS actual_stake, @currency, @sdc, @spt, @srecommend, @username, @currencyname, 0 as statusid, 1, @refno, 0,1, 0
				 
				 
			SELECT 'bettransMFullSP', * FROM @tblBettransmFullSP
			SELECT 'bettransFullSP', * FROM @tblBettransFullSP
		END
		
		IF dbo.BinaryToDecimal(@bitmapLucky) > 0
		BEGIN
			UPDATE ref with (rowlock,updlock) SET @refn=refno=refno+1  WHERE  refid='refno'
			set @refno = @refn + 100000000000
		
			-- lucky
			INSERT INTO dbo.bettransm (custid, transdate, oddsid,  odds, stake, status, betteam, creator, refno, winlostdate, betfrom, apositiontaking, 
				mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount, matchid, matchdate, bettype, spositiontaking, sdiscount, statusID, comstatus)
			OUTPUT INSERTED.transid INTO @tblBettransmLucky(transid)
			SELECT @custid AS custid, GETDATE(),(SELECT top 1 oddsid FROM odds with(NOLOCK) WHERE matchid = m.matchid AND bettype = btype.val AND liveindicator = 0 ), o.val AS odds, @stakelucky AS stake, 'running', bteam.val AS betteam, @custid AS creator, @refno AS refno, m.eventdate AS winlostdate, 'i' AS betfrom, @apt,
				@mpt, @tpt, @playerdc, @dc, @adc, m.matchid, m.eventdate, btype.val AS bettype, @spt, @sdc, 0 AS statusid, @refno
			FROM	@matchinfo m
				INNER JOIN dbo.strSplit(@oddValueInfo, ',') o
					ON m.id = o.rank
				INNER JOIN dbo.strSplit(@betTypeInfo, ',') btype
					ON o.rank = btype.rank
				INNER JOIN dbo.strSplit(@betTeamInfo,',') bteam
					ON btype.rank = bteam.rank	
			
					
			-- bettrans
			INSERT INTO dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, apositiontaking, mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount,
					betteam, creator, winlostdate, betfrom, betcheck, matchid, recommend, mrecommend, ruben, bettype, actual_stake, currency, sdiscount, spositiontaking, srecommend, 
					Username, CurrencyName, statusID, modds, refno, comstatus, oddstype, betid)
			OUTPUT INSERTED.transid, INSERTED.refno INTO @tblBettransLucky(transid, refno)
			SELECT @custid, GETDATE(), 1, 0 AS hdp1, @numberofmatch AS hdp2,  @mainOdds AS odds, @mainStakeLucky AS stake, 'running', @apt, @mpt, @tpt, @playerdc, @dc, @adc,
				 dbo.BinaryToDecimal(reverse(RIGHT(@bitmapLucky,@numberofmatch))) AS betteam, @custid AS creator, (SELECT MAX(eventdate) FROM @matchinfo) AS winlostdate, 'i' AS betfrom, dbo.BinaryToDecimal(@bitmapLucky) AS betcheck,
				 29 AS matchid, @recommend, @mrecommend, 0 AS ruben, 29 AS bettype, @mainStakeLucky AS actual_stake, @currency, @sdc, @spt, @srecommend, @username, @currencyname, 0 as statusid, 1, @refno, 0,1,0
				
			-- single
			
			INSERT INTO dbo.bettrans (custid, transdate, oddsid, odds, stake, status, apositiontaking, mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount,
					betteam, creator, winlostdate, betfrom, betcheck, matchid, recommend, mrecommend, ruben, bettype, actual_stake, currency, sdiscount, spositiontaking, srecommend, 
					Username, CurrencyName, statusID, modds, refno, comstatus, oddstype)
			OUTPUT INSERTED.transid INTO @tblBettransSingleLucky(transid)
			SELECT @custid AS custid, GETDATE(), (SELECT top 1 oddsid FROM odds with(NOLOCK) WHERE matchid = m.matchid AND bettype = btype.val AND liveindicator = 0 ), o.val AS odds, @stakelucky AS stake, 'running', @apt, @mpt, @tpt, @playerdc, @dc, @adc,bteam.val, @custid
				, m.eventdate, 'i', NULL, m.matchid, @recommend, @mrecommend, 0, btype.val, @stakelucky, @currency, @sdc, @spt, @srecommend,
				@username, @currencyName, 0, 0, 100000000000,0, 4
			FROM	@matchinfo m
				INNER JOIN dbo.strSplit(@oddValueInfo, ',') o
					ON m.id = o.rank
				INNER JOIN dbo.strSplit(@betTypeInfo, ',') btype
					ON o.rank = btype.rank
				INNER JOIN dbo.strSplit(@betTeamInfo,',') bteam
					ON btype.rank = bteam.rank	
			
						
			SELECT 'bettransMLucky', * FROM @tblBettransmLucky
			SELECT 'bettransLucky', * FROM @tblBettransLucky
			SELECT 'bettransSingleLucky', * FROM @tblBettransSingleLucky
		END	
	END	
	
	IF dbo.BinaryToDecimal(@bitmapMixparlay) > 0 AND @numberofmatch BETWEEN 21 AND 100
	BEGIN
		UPDATE ref with (rowlock,updlock) SET @refn=refno=refno+1  WHERE  refid='refno'
		set @refno = @refn + 100000000000
		
		-- bettransm
		INSERT INTO dbo.bettransm (custid, transdate, oddsid,  odds, stake, status, betteam, creator, refno, winlostdate, betfrom, apositiontaking, 
			mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount, matchid, matchdate, bettype, spositiontaking, sdiscount, statusID, comstatus)
		OUTPUT INSERTED.transid INTO @tblBettransmMixParlay(transid)
		SELECT @custid AS custid, GETDATE(),(SELECT top 1 oddsid FROM odds with(NOLOCK) WHERE matchid = m.matchid AND bettype = btype.val AND liveindicator = 0 ), o.val AS odds, @mixparlay AS stake, 'running', bteam.val AS betteam, @custid AS creator, @refno AS refno, m.eventdate AS winlostdate, 'i' AS betfrom, @apt,
			@mpt, @tpt, @playerdc, @dc, @adc, m.matchid, m.eventdate, btype.val AS bettype, @spt, @sdc, 0 AS statusid, @refno
		FROM	@matchinfo m
			INNER JOIN dbo.strSplit(@oddValueInfo, ',') o
				ON m.id = o.rank
			INNER JOIN dbo.strSplit(@betTypeInfo, ',') btype
				ON o.rank = btype.rank
			INNER JOIN dbo.strSplit(@betTeamInfo,',') bteam
				ON btype.rank = bteam.rank	
				
		
		-- bettrans
		INSERT INTO dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, apositiontaking, mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount,
				betteam, creator, winlostdate, betfrom, betcheck, matchid, recommend, mrecommend, ruben, bettype, actual_stake, currency, sdiscount, spositiontaking, srecommend, 
				Username, CurrencyName, statusID, modds, refno, comstatus, oddstype, betid)
		OUTPUT INSERTED.transid, INSERTED.refno INTO @tblBettransMixParlay(transid, refno)
		SELECT @custid, GETDATE(), 1, 0 AS hdp1, @numberofmatch AS hdp2,  @mainOdds AS odds, @mixparlay*@numberofmatch AS stake, 'running', @apt, @mpt, @tpt, @playerdc, @dc, @adc,
			 dbo.BinaryToDecimal(reverse(RIGHT(@bitmapMixparlay,@numberofmatch))) AS betteam, @custid AS creator, (SELECT MAX(eventdate) FROM @matchinfo) AS winlostdate, 'i' AS betfrom, dbo.BinaryToDecimal(@bitmapMixparlay) AS betcheck,
			 29 AS matchid, @recommend, @mrecommend, 0 AS ruben, 29 AS bettype, @mixparlay*@numberofmatch AS actual_stake, @currency, @sdc, @spt, @srecommend, @username, @currencyname, 0 as statusid, 1, @refno, 0,1,0
			 
			 
		SELECT 'BettransMMixParlay', * FROM @tblBettransmMixParlay	
		SELECT 'BettransMixParlay	', * FROM @tblBettransMixParlay
	END
END
