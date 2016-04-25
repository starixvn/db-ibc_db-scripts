USE [bodb02]
GO

ALTER PROCEDURE [dbo].[NAP_Admin_Calculate_1_version2] 
     @matchid INT
    ,@bettype                SMALLINT
    ,@fth                    SMALLMONEY    = NULL
    ,@fta                    SMALLMONEY    = NULL 
    ,@SelectedSet            VARCHAR(50) = NULL 
    ,@TotalGameHomeSet1        SMALLMONEY    = NULL 
    ,@TotalGameHomeSet2        SMALLMONEY    = NULL 
    ,@TotalGameHomeSet3        SMALLMONEY    = NULL 
    ,@TotalGameHomeSet4        SMALLMONEY    = NULL 
    ,@TotalGameHomeSet5        SMALLMONEY    = NULL 
    ,@TotalGameAwaySet1        SMALLMONEY    = NULL 
    ,@TotalGameAwaySet2        SMALLMONEY    = NULL 
    ,@TotalGameAwaySet3        SMALLMONEY    = NULL 
    ,@TotalGameAwaySet4        SMALLMONEY    = NULL 
    ,@TotalGameAwaySet5        SMALLMONEY    = NULL 
    ,@isRefundHT            BIT = 0
    ,@betcount                INT = 0
    -- add any params, please modify script in 'special section'
AS
/*
    Created by: Kathy
    Date:20140211
    Task: Settlement 
    DB: DBTRANS.BODB02
    
    Revisions:
        - 20140610@Kathy: Using clustered index(CIX_recommend_matchid_bettype) in DB052, DB053, DB054        
        - 20141017@Jamie: Sporting Solution for Tennis [Redmine:#23034]
        - 20150415@Jamie: Settlement Betradar phase 2 [Redmine: #27212]
        - 20150909@Kathy: Intergrate Myanmar Odds ( 4 new bettypes: 301->304): add bettype 301
        - 20151026@Kathy: Change Myanmar Odds commision formula [Redmine:#46284]
		- 20151207@Patrick: Database - Change datatype [Redmine: #48660]
        
*/
BEGIN
    IF @betcount = 0 AND @@SERVERNAME NOT LIKE N'DBIOM%' RETURN

    SET NOCOUNT ON

    DECLARE @modds MONEY
        ,@commWinRate SMALLMONEY
        ,@commLostRate SMALLMONEY
        ,@RemoteCount INT

    IF @@SERVERNAME IN ('DB04', 'DB042', 'DB043', 'DB044') RETURN

    
    CREATE TABLE #tempCust(custid INT NOT NULL, ticketCount INT NOT NULL)
	DECLARE @RunningTotal INT, @Index INT

	SELECT @Index = 1, @RunningTotal = 1

    INSERT INTO #tempCust(custid, ticketCount)
    SELECT custid, COUNT(1) AS ticketCount
    FROM dbo.bettrans WITH(NOLOCK) 
    WHERE matchid = @matchid and bettype = @bettype
	GROUP BY custid
		
	PRINT @@ROWCOUNT

	UPDATE #tempCust
	SET @RunningTotal = ticketCount = @RunningTotal + ticketCount

	--select * from #tempCust

    DECLARE @currList TABLE(custid int)
	--DECLARE @TransIds TABLE(TransId BIGINT)

	--DECLARE @RowEffected INT

    WHILE 1=1
    BEGIN
        DELETE FROM @currList
		--DELETE FROM @TransIds

        DELETE t
        OUTPUT DELETED.custid INTO @currList
		FROM #tempCust t
		WHERE t.ticketCount <= 5000 * @Index

        IF @@ROWCOUNT = 0 BREAK
            
		SET @Index =  @Index + 1

        UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
		SET @fth = CASE WHEN bettype IN (154,155,1311, 1316) AND BetID = 801 AND @SelectedSet LIKE '%1%' THEN @TotalGameHomeSet1 
						WHEN bettype IN (154,155,1311, 1316) AND BetID = 802 AND @SelectedSet LIKE '%2%' THEN @TotalGameHomeSet2 
						WHEN bettype IN (154,155,1311, 1316) AND BetID = 803 AND @SelectedSet LIKE '%3%' THEN @TotalGameHomeSet3 
						WHEN bettype IN (154,155,1311, 1316) AND BetID = 804 AND @SelectedSet LIKE '%4%' THEN @TotalGameHomeSet4 
						WHEN bettype IN (154,155,1311, 1316) AND BetID = 805 AND @SelectedSet LIKE '%5%' THEN @TotalGameHomeSet5
						ELSE @fth END 
			,@fta = CASE WHEN bettype IN (154,155,1311, 1316) AND BetID = 801 AND @SelectedSet LIKE '%1%' THEN @TotalGameAwaySet1 
							WHEN bettype IN (154,155,1311, 1316) AND BetID = 802 AND @SelectedSet LIKE '%2%' THEN @TotalGameAwaySet2
							WHEN bettype IN (154,155,1311, 1316) AND BetID = 803 AND @SelectedSet LIKE '%3%' THEN @TotalGameAwaySet3 
							WHEN bettype IN (154,155,1311, 1316) AND BetID = 804 AND @SelectedSet LIKE '%4%' THEN @TotalGameAwaySet4 
							WHEN bettype IN (154,155,1311, 1316) AND BetID = 805 AND @SelectedSet LIKE '%5%' THEN @TotalGameAwaySet5
							ELSE @fta END        
			,@modds = CASE betteam
				WHEN N'h' THEN (hdp2 - hdp1) + (@fth - livehomescore) - (@fta - liveawayscore)
				WHEN N'a' THEN (hdp1 - hdp2) - (@fth - livehomescore) + (@fta - liveawayscore)
				END
			,modds = @modds
			,@commWinRate = CASE comstatus -- 0 : pay normal, both win/lost -- 1 : pay 'double' ONLY on lost
				WHEN '0' THEN 1
				WHEN '1' THEN 0
				ELSE 1
				END
			,@commLostRate = CASE comstatus
				WHEN '0' THEN 1
				WHEN '1' THEN 2
				ELSE 1
				END
			,--'s','m'
			WinLost = CASE 
				WHEN @modds > 0.25 THEN actual_stake + stake * (CASE 
						WHEN odds < 0 THEN 1
						ELSE (CASE 
								WHEN bettype IN (4, 5, 6, 1201) THEN odds - 1
								ELSE odds END
								) END
						)
				WHEN @modds = 0.25 THEN actual_stake + stake * (CASE 
						WHEN odds < 0 THEN 1
						ELSE (CASE 
								WHEN bettype IN (4, 5, 6, 1201) THEN odds - 1
								ELSE odds END
								) END
						) * 0.5
				WHEN @modds =  0 AND bettype <> 301    THEN actual_stake
				WHEN @modds =  0 AND bettype = 301    THEN CASE 
															WHEN oddsspread = 0 THEN actual_stake
															WHEN oddsspread > 0 THEN actual_stake + stake * odds * (oddsspread/100) -- oddsspread > 0: WON
															ELSE actual_stake * (1 - ABS(oddsspread/100))  -- oddsspread < 0: LOSE
															END
				WHEN @modds = - 0.25 THEN actual_stake * 0.5
				WHEN @modds < - 0.25 THEN 0
				END
			,aWinLost = CASE 
				WHEN @modds > 0.25 THEN stake * (CASE 
						WHEN odds < 0 THEN 1
						ELSE (CASE 
								WHEN bettype IN (4, 5, 6, 1201) THEN odds - 1
								ELSE odds END
								) END
						) * - apositiontaking
				WHEN @modds = 0.25 THEN stake * (CASE 
						WHEN odds < 0 THEN 1
						ELSE (CASE 
								WHEN bettype IN (4, 5, 6, 1201) THEN odds - 1
								ELSE odds END
								) END
						) * - apositiontaking * 0.5
				WHEN @modds =  0 AND bettype <> 301    THEN 0
				WHEN @modds =  0 AND bettype = 301    THEN CASE 
															WHEN oddsspread = 0 THEN 0
															WHEN oddsspread > 0 THEN stake * odds * (oddsspread/100) * -apositiontaking -- oddsspread > 0: WON
															ELSE actual_stake * ABS(oddsspread/100) * apositiontaking -- oddsspread < 0: LOSE
															END
				WHEN @modds = - 0.25 THEN actual_stake * apositiontaking * 0.5
				WHEN @modds < - 0.25 THEN actual_stake * apositiontaking
				END
			,mWinLost = CASE 
				WHEN @modds > 0.25 THEN stake * (CASE 
						WHEN odds < 0 THEN 1
						ELSE (CASE 
								WHEN bettype IN (4, 5, 6, 1201) THEN odds - 1
								ELSE odds END
								) END
						) * - mpositiontaking
				WHEN @modds = 0.25 THEN stake * (CASE 
						WHEN odds < 0 THEN 1
						ELSE (CASE 
								WHEN bettype IN (4, 5, 6, 1201) THEN odds - 1
								ELSE odds END
								) END
						) * - mpositiontaking * 0.5
				WHEN @modds =  0 AND bettype <> 301        THEN 0
				WHEN @modds =  0 AND bettype = 301        THEN CASE 
																WHEN oddsspread = 0 THEN 0
																WHEN oddsspread > 0 THEN stake * odds * (oddsspread/100) * -mpositiontaking -- oddsspread > 0: WON
																ELSE actual_stake * ABS(oddsspread/100) * mpositiontaking -- oddsspread < 0: LOSE
																END
				WHEN @modds = - 0.25 THEN actual_stake * mpositiontaking * 0.5
				WHEN @modds < - 0.25 THEN actual_stake * mpositiontaking
				END
			,sWinLost = CASE 
				WHEN @modds > 0.25 THEN stake * (CASE 
						WHEN odds < 0 THEN 1
						ELSE (CASE 
								WHEN bettype IN (4, 5, 6, 1201) THEN odds - 1
								ELSE odds END
								) END
						) * - spositiontaking
				WHEN @modds = 0.25 THEN stake * (CASE 
						WHEN odds < 0 THEN 1
						ELSE (CASE 
								WHEN bettype IN (4, 5, 6, 1201) THEN odds - 1
								ELSE odds END
								) END
						) * - spositiontaking * 0.5
				WHEN @modds =  0 AND bettype <> 301       THEN 0
				WHEN @modds =  0 AND bettype = 301       THEN CASE 
																WHEN oddsspread = 0 THEN 0
																WHEN oddsspread > 0 THEN stake * odds * (oddsspread/100) * -spositiontaking
																ELSE actual_stake * ABS(oddsspread/100) * spositiontaking 
																END
				WHEN @modds = - 0.25 THEN actual_stake * spositiontaking * 0.5
				WHEN @modds < - 0.25 THEN actual_stake * spositiontaking
				END
			,PlayerComm = CASE 
				WHEN @modds > 0.25 THEN @commWinRate * playerdiscount * stake
				WHEN @modds = 0.25 THEN @commWinRate * playerdiscount * stake * 0.5
				WHEN @modds =  0 AND bettype <> 301        THEN 0
				WHEN @modds =  0 AND bettype = 301        THEN CASE
																WHEN oddsspread = 0 THEN 0
																WHEN oddsspread > 0 THEN @commWinRate * playerdiscount * stake * (oddsspread/100)
																ELSE @commLostRate * playerdiscount * stake * ABS(oddsspread/100)
																END
				WHEN @modds = - 0.25 THEN @commLostRate * playerdiscount * stake * 0.5
				WHEN @modds < - 0.25 THEN @commLostRate * playerdiscount * stake
				END
			,Comm = CASE 
				WHEN @modds > 0.25 THEN @commWinRate * discount * stake * (1 - apositiontaking)
				WHEN @modds = 0.25 THEN @commWinRate * discount * stake * (1 - apositiontaking) * 0.5
				WHEN @modds =  0 AND bettype <> 301       THEN 0
				WHEN @modds =  0 AND bettype = 301       THEN CASE 
																WHEN oddsspread = 0 THEN 0
																WHEN oddsspread > 0 THEN @commWinRate * discount * stake * (oddsspread/100) * (1-apositiontaking)
																ELSE @commLostRate * discount * stake * ABS(oddsspread/100) * (1-apositiontaking)
																END
				WHEN @modds = - 0.25 THEN @commLostRate * discount * stake * (1 - apositiontaking) * 0.5
				WHEN @modds < - 0.25 THEN @commLostRate * discount * stake * (1 - apositiontaking)
				END
			,aComm = CASE 
				WHEN @modds > 0.25 THEN @commWinRate * adiscount * stake * (1 - (mpositiontaking + apositiontaking))
				WHEN @modds = 0.25 THEN @commWinRate * adiscount * stake * (1 - (mpositiontaking + apositiontaking)) * 0.5
				WHEN @modds =  0 AND bettype <> 301        THEN 0
				WHEN @modds =  0 AND bettype = 301        THEN CASE
																WHEN oddsspread = 0 THEN 0
																WHEN oddsspread > 0 THEN @commWinRate * adiscount * stake * (oddsspread/100) * (1-(mpositiontaking+apositiontaking))
																ELSE @commLostRate * adiscount * stake * ABS(oddsspread/100) * (1-(mpositiontaking+apositiontaking))
																END
				WHEN @modds = - 0.25 THEN @commLostRate * adiscount * stake * (1 - (mpositiontaking + apositiontaking)) * 0.5
				WHEN @modds < - 0.25 THEN @commLostRate * adiscount * stake * (1 - (mpositiontaking + apositiontaking))
				END
			,sComm = CASE 
				WHEN @modds > 0.25 THEN @commWinRate * sdiscount * stake * (1 - (spositiontaking + mpositiontaking + apositiontaking))
				WHEN @modds = 0.25 THEN @commWinRate * sdiscount * stake * (1 - (spositiontaking + mpositiontaking + apositiontaking)) * 0.5
				WHEN @modds =  0 AND bettype <> 301        THEN 0
				WHEN @modds =  0 AND bettype = 301        THEN CASE
																WHEN oddsspread = 0 THEN 0
																WHEN oddsspread > 0 THEN @commWinRate * sdiscount * stake * (oddsspread/100) * (1-(spositiontaking+mpositiontaking+apositiontaking))
																ELSE @commLostRate * sdiscount * stake * ABS(oddsspread/100) * (1-(spositiontaking+mpositiontaking+apositiontaking))
																END
				WHEN @modds = - 0.25 THEN @commLostRate * sdiscount * stake * (1 - (spositiontaking + mpositiontaking + apositiontaking)) * 0.5
				WHEN @modds < - 0.25 THEN @commLostRate * sdiscount * stake * (1 - (spositiontaking + mpositiontaking + apositiontaking))
				END
			,STATUS = CASE 
				WHEN @modds > 0 THEN N'WON'
				WHEN @modds = 0 AND bettype <> 301 THEN 'DRAW'
				WHEN @modds = 0 AND bettype = 301 THEN CASE WHEN oddsspread = 0 THEN 'DRAW' 
															WHEN oddsspread > 0 THEN 'WON'
															ELSE 'LOSE'
															END
				WHEN @modds < 0 THEN N'LOSE'
				END
			,StatusID = CASE 
				WHEN @modds > 0 THEN 112 --WON
				WHEN @modds = 0 AND bettype <> 301 THEN 111 --DRAW
				WHEN @modds = 0 AND bettype = 301 THEN CASE WHEN oddsspread = 0 THEN 111 
															WHEN oddsspread > 0 THEN 112
															ELSE 113
															END
				WHEN @modds < 0 THEN 113 --LOSE
				END
			,ruben = 1
		--OUTPUT DELETED.TransId INTO @TransIds
		WHERE matchid = @matchid 
			AND exists (select top 1 1 from @currList t where bettrans.custid = t.custid)--custid in (select custid from @currList)
			AND bettype = @bettype 
			AND statusID NOT IN (101,102) -- REJECT & VOID 
			AND 1 = CASE WHEN @bettype = 183 and @isRefundHT = 1 THEN 0 ELSE 1 END
			AND 1 = CASE WHEN @Bettype NOT IN (154,155,1311, 1316) THEN 1
							WHEN @Bettype IN (154,155,1311, 1316) AND @SelectedSet LIKE '%1%' AND BetID = 801 THEN 1
							WHEN @Bettype IN (154,155,1311, 1316) AND @SelectedSet LIKE '%2%' AND BetID = 802 THEN 1
							WHEN @Bettype IN (154,155,1311, 1316) AND @SelectedSet LIKE '%3%' AND BetID = 803 THEN 1
							WHEN @Bettype IN (154,155,1311, 1316) AND @SelectedSet LIKE '%4%' AND BetID = 804 THEN 1
							WHEN @Bettype IN (154,155,1311, 1316) AND @SelectedSet LIKE '%5%' AND BetID = 805 THEN 1
							ELSE 0 END            
		PRINT @@ROWCOUNT
		--SET @RowEffected = @@ROWCOUNT
		--PRINT @RowEffected
		--IF @RowEffected > 5000
		--BEGIN
		--	SELECT * FROM @TransIds
		--	SELECT * FROM @currList
		--	select count(1) from dbo.bettrans where custid in (select custid from @currList) and bettype = 1 and matchid = @matchid
		--	RETURN
		--END

		--WAITFOR DELAY '00:00:00.280'
		
    END
	DROP TABLE #tempCust
END