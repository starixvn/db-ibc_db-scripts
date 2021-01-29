/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
/*
	Created: 20201102@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - PRMS - Generate data rmBettrans_UAT 
	-- Regen data rmBettrans_UAT Winlostdate >
*/

--select * FROM dbo.rmSumWinloss_Old with(nolock)

 SET IDENTITY_INSERT dbo.rmSettings ON
-- Insert new flag for rmBettrans_uat
INSERT INTO dbo.rmSettings (VID, VName, VValue) 
SELECT 12, 'rmBettrans', VValue FROM dbo.rmSettings  WITH(NOLOCK) WHERE Vname = 'rmBettransSync'


INSERT INTO dbo.rmSettings (VID, VName, VValue) 
SELECT 13, 'rmCopyDataMBU', VValue FROM dbo.rmSettings  WITH(NOLOCK) WHERE Vname = 'rmCopyData'

INSERT INTO dbo.rmSettings (VID, VName, VValue) 
SELECT 14, 'rmSumDataMBU', VValue FROM dbo.rmSettings  WITH(NOLOCK) WHERE Vname = 'rmSumData'

SET IDENTITY_INSERT dbo.rmSettings OFF

---------------------------------------
BEGIN
	DECLARE @f_date smalldatetime
	DECLARE @t_date smalldatetime
	DECLARE @isBreak BIT = 0

	SELECT @f_date = MIN(winlostdate), @t_date = MAX(winlostdate) FROM dbo.rmBettrans WITH(NOLOCK)

	-- Generate data for rmbettrans_UAT table
	CREATE TABLE #rmBettrans
	(
		transid				bigint primary key
		,custid				int
		,transdate			datetime
		,oddsid				int
		,hdp1				smallmoney
		,hdp2				smallmoney
		,odds				smallmoney
		,stake				money
		,status				nvarchar(10)
		,winlost			money
		,awinlost			money
		,mwinlost			money
		,playercomm			money
		,comm				money
		,acomm				money
		,apositiontaking	smallmoney
		,mpositiontaking	smallmoney
		,tpositiontaking	smallmoney
		,playerdiscount		decimal(9,8)
		,discount			decimal(9,8)
		,adiscount			decimal(9,8)
		,livehomescore		smallint
		,liveawayscore		smallint
		,liveindicator		bit
		,betteam			nvarchar(10)
		,creator			int
		,refno				bigint
		,comstatus			nvarchar(20)
		,winlostdate		smalldatetime
		,betfrom			nvarchar(1)
		,betcheck			nvarchar(50)
		,checktime			datetime
		,oddsspread			smallmoney
		,actualrate			float
		,matchid			int
		,recommend			int
		,mrecommend			int
		,ruben				tinyint
		,betid				bigint
		,statuswinlost		tinyint
		,modds				smallmoney
		,bettype			smallint
		,betdaqid			bigint
		,actual_stake		money
		,currency			tinyint
		,ip					nvarchar(15)
		,transdesc			nvarchar(1000)
		,sdiscount			decimal(9,8)
		,scomm				money
		,spositiontaking	smallmoney
		,swinlost			money
		,srecommend			int
		,Username			nvarchar(50)
		,CurrencyName		nvarchar(50)
		,virtualrate		float
		,oddstype			tinyint
		,statusID			tinyint
		,currency2			tinyint
		,balance			money
		,SecAcceptFlag		bit
		,transid2			bigint
		,combo				int
		,odds2				money
		,TotalBet			int
		,epositiontaking	smallmoney
	)
	CREATE  index idx_#rmBettrans_bettype ON #rmBettrans(bettype) INCLUDE (transid, refno, transid2)


	CREATE TABLE #__tmpByBatch
	(
		transid				bigint
		,custid				int
		,transdate			datetime
		,oddsid				int
		,hdp1				smallmoney
		,hdp2				smallmoney
		,odds				smallmoney
		,stake				money
		,status				nvarchar(10)
		,winlost			money
		,awinlost			money
		,mwinlost			money
		,playercomm			money
		,comm				money
		,acomm				money
		,apositiontaking	smallmoney
		,mpositiontaking	smallmoney
		,tpositiontaking	smallmoney
		,playerdiscount		decimal(9,8)
		,discount			decimal(9,8)
		,adiscount			decimal(9,8)
		,livehomescore		smallint
		,liveawayscore		smallint
		,liveindicator		bit
		,betteam			nvarchar(10)
		,creator			int
		,refno				bigint
		,comstatus			nvarchar(20)
		,winlostdate		smalldatetime
		,betfrom			nvarchar(1)
		,betcheck			nvarchar(50)
		,checktime			datetime
		,oddsspread			smallmoney
		,actualrate			float
		,matchid			int
		,recommend			int
		,mrecommend			int
		,ruben				tinyint
		,betid				bigint
		,statuswinlost		tinyint
		,modds				smallmoney
		,bettype			smallint
		,betdaqid			bigint
		,actual_stake		money
		,currency			tinyint
		,ip					nvarchar(15)
		,transdesc			nvarchar(1000)
		,sdiscount			decimal(9,8)
		,scomm				money
		,spositiontaking	smallmoney
		,swinlost			money
		,srecommend			int
		,Username			nvarchar(50)
		,CurrencyName		nvarchar(50)
		,virtualrate		float
		,oddstype			tinyint
		,statusID			tinyint
		,currency2			tinyint
		,balance			money
		,SecAcceptFlag		bit
		,transid2			bigint
		,combo				int
		,odds2				money
		,TotalBet			int
		,epositiontaking	smallmoney
	)

	WHILE 1 = 1
	BEGIN

		IF @f_date >= @t_date -- Current BU Date
		BEGIN
			SET @isBreak = 1
		END

		INSERT INTO #rmBettrans
		(
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
			,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
			,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid
			,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc
			,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,currency2
			,balance,SecAcceptFlag,epositiontaking,transid2,combo,odds2,TotalBet
		)
		SELECT transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
			,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
			,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid
			,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc
			,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,currency2
			,balance,SecAcceptFlag,epositiontaking,transid2,combo,odds2,TotalBet
		FROM dbo.rmBettrans b WITH(NOLOCK) 
		WHERE b.winlostdate = @f_date

		WHILE 1= 1
		BEGIN
			TRUNCATE TABLE #__tmpByBatch

			DELETE TOP (5000) FROM #rmBettrans
			OUTPUT DELETED.*
			INTO #__tmpByBatch


			UPDATE  b
			SET b.transid2 = s.sporttype
			FROM #__tmpByBatch b
			CROSS APPLY (
						SELECT CASE
									-------------------------------
									WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) NOT IN (1,2) THEN MIN(sporttype)
									------------------------------- 
									WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 1 AND SUM(DISTINCT Saba) = 0 THEN -3 
									WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 1 AND SUM(DISTINCT Saba) > 0 THEN -4
									WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 1 AND SUM(DISTINCT Saba) < 0 THEN  1
									------------------------------
									WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 2 AND SUM(DISTINCT Saba) = 0 THEN -1
									WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 2 AND SUM(DISTINCT Saba) > 0 THEN -5
									WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 2 AND SUM(DISTINCT Saba) < 0 THEN  2

									------------------------------
									WHEN COUNT(DISTINCT sporttype) <> 1 AND MIN(sporttype) = 1 THEN -3
									ELSE -1 END AS sporttype 
						FROM
						(
							SELECT m.sporttype, CASE WHEN  l.LeagueGroupID IN (42, 74) THEN 1 ELSE -1 END Saba
							FROM bodb02.dbo.bettransm bm WITH (NOLOCK) 
								INNER JOIN bodb02.dbo.match m WITH (NOLOCK) ON bm.matchid = m.matchid
								INNER JOIN bodb02.dbo.League l WITH(NOLOCK) ON m.leagueid = l.leagueid
							WHERE bm.refno = b.refno and b.bettype = 29

							UNION ALL
							SELECT m.sporttype, CASE WHEN  l.LeagueGroupID IN (42, 74) THEN 1 ELSE -1 END Saba
							FROM bodb02.dbo.bettransm14 bm WITH (NOLOCK)
								INNER JOIN bodb02.dbo.match14 m WITH (NOLOCK) ON bm.matchid = m.matchid
								INNER JOIN bodb02.dbo.League l WITH(NOLOCK) ON m.leagueid = l.leagueid
							WHERE bm.refno = b.refno  and b.bettype = 29
						) s
			) s

			INSERT INTO [dbo].[rmBettrans_UAT]
			(
				transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
				,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
				,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid
				,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc
				,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,currency2
				,balance,SecAcceptFlag,epositiontaking,transid2,combo,odds2,TotalBet
			)
			SELECT 
				transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
				,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
				,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid
				,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc
				,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,currency2
				,balance,SecAcceptFlag,epositiontaking,transid2,combo,odds2,TotalBet
			FROM #__tmpByBatch

			IF @@ROWCOUNT < 5000
				BREAK
		END

		SELECT @f_date = DATEADD(DAY, 1, @f_date)

		IF @isBreak = 1
			BREAK
	END

	DROP TABLE #__tmpByBatch
	DROP TABLE #rmBettrans
END
