USE [bodb_Summary]
GO

ALTER PROCEDURE [dbo].[DBA_sum_winloss_old_Ins]
	@transids		VARCHAR(MAX) = '',
	@transidsRnG	VARCHAR(MAX) = '',
	@recommend		INT,
	@mrecommend		INT,
	@srecommend		INT,
	@winlostdate	DATETIME,
	@sporttype		INT
AS

/*
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @transid TABLE (transid BIGINT)

	IF @transids <> ''
		INSERT INTO @transid (transid)
		SELECT val FROM bodb02.dbo.strSplit(@transids, ',')
	ELSE IF @transidsRnG <> ''
		INSERT INTO @transid (transid)
		SELECT val FROM bodb02.dbo.strSplit(@transidsRnG, ',')

	DECLARE @tmp_sum_winloss TABLE
	(
		custid INT,recommend INT,mrecommend INT,srecommend INT,
		turnover MONEY, betcount INT,
		winlost MONEY, awinlost MONEY, mwinlost MONEY, swinlost MONEY,
		playercomm MONEY, comm MONEY, acomm MONEY, scomm MONEY,
		turnoverNoDraw MONEY,
		GrossCommSuper MONEY, GrossCommMaster MONEY, GrossCommAgent MONEY, GrossCommMember MONEY
	)

	-- sum_winloss
	IF @transids <> '' 
		INSERT INTO @tmp_sum_winloss
		SELECT
			b.custid,b.recommend,b.mrecommend,b.srecommend,
			SUM(b.stake) AS turnover, COUNT(b.transid) AS betcount,
			SUM(b.winlost-b.actual_stake) AS winlost, SUM(b.awinlost) AS awinlost, SUM(b.mwinlost) AS mwinlost, SUM(b.swinlost) AS swinlost,
			SUM(playercomm) AS playercomm, SUM(comm) AS comm, SUM(acomm) AS acomm, SUM(scomm) AS scomm,
			SUM(b.stake) AS turnoverNoDraw,
			SUM(CASE tpositiontaking WHEN 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommSuper,
			SUM(CASE tpositiontaking WHEN 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommMaster,
			SUM(CASE WHEN apositiontaking+mpositiontaking = 1 THEN 0 ELSE ISNULL(acomm/(1-apositiontaking-mpositiontaking), 0) END) AS GrossCommAgent,
			SUM(CASE WHEN apositiontaking = 1 THEN 0 ELSE ISNULL(comm/(1-apositiontaking),0) END) AS GrossCommMember
		FROM DBTXN.bodb02.dbo.bettrans b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE b.transid = t.transid)
		GROUP BY b.custid,b.recommend,b.mrecommend,b.srecommend
	ELSE IF @transidsRnG <> ''
		INSERT INTO @tmp_sum_winloss
		SELECT
			b.custid,b.recommend,b.mrecommend,b.srecommend,
			SUM(b.stake) AS turnover, COUNT(DISTINCT b.Refno) AS betcount,
			SUM(b.winlost-b.actual_stake) AS winlost, SUM(b.awinlost) AS awinlost, SUM(b.mwinlost) AS mwinlost, SUM(b.swinlost) AS swinlost,
			SUM(playercomm) AS playercomm, SUM(comm) AS comm, SUM(acomm) AS acomm, SUM(scomm) AS scomm,
			SUM(CASE WHEN statusID = 111 THEN 0 ELSE b.stake END) AS turnoverNoDraw,
			SUM(CASE tpositiontaking WHEN 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommSuper,
			SUM(CASE tpositiontaking WHEN 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommMaster,
			SUM(CASE WHEN apositiontaking+mpositiontaking = 1 THEN 0 ELSE ISNULL(acomm/(1-apositiontaking-mpositiontaking), 0) END) AS GrossCommAgent,
			SUM(CASE WHEN apositiontaking = 1 THEN 0 ELSE ISNULL(comm/(1-apositiontaking),0) END) AS GrossCommMember
		FROM DBTXN.bodb02.dbo.bettransRnG b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE b.transid = t.transid)
		GROUP BY b.custid,b.recommend,b.mrecommend,b.srecommend
	
	MERGE dbo.sum_winloss_old AS s
	USING (
		SELECT custid, roleId, recommend, mrecommend, srecommend, @winlostdate AS winlostdate, @sporttype AS sporttype,
			turnover, betcount, winlost, awinlost, mwinlost, swinlost, playercomm, comm, acomm, scomm, turnoverNoDraw, GrossComm
		FROM (
			SELECT custid, 1 AS roleId, recommend, mrecommend, srecommend,
				turnover, betcount, winlost, awinlost, mwinlost, swinlost, playercomm, comm, acomm, scomm, turnoverNoDraw, GrossCommMember AS GrossComm
			FROM @tmp_sum_winloss
			UNION ALL
			SELECT recommend, 2 AS roleId, @recommend, @mrecommend, @srecommend,
				SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
				SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(turnoverNoDraw), SUM(GrossCommAgent)
			FROM @tmp_sum_winloss
			GROUP BY recommend
			UNION ALL
			SELECT mrecommend, 3 AS roleId, 0, @mrecommend, @srecommend,
				SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
				SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(turnoverNoDraw), SUM(GrossCommMaster)
			FROM @tmp_sum_winloss
			GROUP BY mrecommend
			UNION ALL
			SELECT srecommend, 4 AS roleId, 0, 0, @srecommend,
				SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
				SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(turnoverNoDraw), SUM(GrossCommSuper)
			FROM @tmp_sum_winloss
			GROUP BY srecommend
		) AS A
	) AS src
		ON s.custid = src.custid AND s.winlostdate = src.winlostdate AND s.sporttype = src.sporttype
	WHEN MATCHED THEN
		UPDATE SET
			s.turnover = ISNULL(s.turnover, 0) + ISNULL(src.turnover, 0),
			s.BetCount = ISNULL(s.BetCount, 0) + ISNULL(src.betcount, 0),
			s.winlost = ISNULL(s.winlost, 0) + ISNULL(src.winlost, 0),
			s.awinlost = ISNULL(s.awinlost, 0) + ISNULL(src.awinlost, 0),
			s.mwinlost = ISNULL(s.mwinlost, 0) + ISNULL(src.mwinlost, 0),
			s.swinlost = ISNULL(s.swinlost, 0) + ISNULL(src.swinlost, 0),
			s.playercomm = ISNULL(s.playercomm, 0) + ISNULL(src.playercomm, 0),
			s.comm = ISNULL(s.comm, 0) + ISNULL(src.comm, 0),
			s.acomm = ISNULL(s.acomm, 0) + ISNULL(src.acomm, 0),
			s.scomm = ISNULL(s.scomm, 0) + ISNULL(src.scomm, 0),
			s.TunroverNoDraw = ISNULL(s.TunroverNoDraw, 0) + ISNULL(src.turnoverNoDraw, 0),
			s.grosscomm = ISNULL(s.grosscomm, 0) + ISNULL(src.grosscomm, 0)
	WHEN NOT MATCHED THEN
		INSERT
		(
			winlostdate,username,custid,roleid,recommend,mrecommend,srecommend,turnover,
			winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			BetCount,grosscomm,sporttype,bettype,netTurnover,TunroverNoDraw
		)
		VALUES
		(
			src.winlostdate, '',src.custId,src.roleId,src.recommend,src.mrecommend,src.srecommend,src.turnover,
			src.winlost,src.awinlost,src.mwinlost,src.swinlost,src.playercomm,src.comm,src.acomm,src.scomm,
			src.betcount,src.grosscomm,src.sporttype,0,0,src.turnoverNoDraw
		);
END
GO