/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Create: 20240208@Sophia
	Task: copy data of bet Statement by manual void ticket [Redmine: #200940] 
	DB: DBACC-bodb02
*/ 
 
 
BEGIN 
	SET NOCOUNT ON 

	Declare @min_winlostdate smalldatetime,
			@max_winlostdate smalldatetime


	SELECT
		@min_winlostdate = '20240129',
		@max_winlostdate = '20240201'

	 DELETE bodb_Report.dbo.statement 
	 WHERE  winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			  AND CUSTID IN (109833810,109833839,109833878,109833898,
								13924584,88557576,98754632)
	 
 
	INSERT INTO bodb_Report.dbo.statement (custid,accdate,totalamt,transtype,transdesc)
	select custid,winlostdate accdate,sum(winlost-actual_stake) totalamt,CAST('BET' AS varchar(128)) transtype, CAST('Betting' AS varchar(1000)) AS transdesc
		from bettrans14 bettrans with (nolock)
		where bettype between 1 and 19999 and winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			  AND CUSTID IN (109833810,109833839,109833878,109833898,
								13924584,88557576,98754632) 
		group by winlostdate,custid
		 
	UNION ALL
	--INSERT INTO DB06.bodb_Report.dbo.statement
		select custid,winlostdate accdate,sum(playercomm) totalamt,'COM' transtype, 'Commission' transdesc
		from dbo.bettrans14 bettrans  with (nolock)
		where bettype between 1 and 19999 and winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
				AND CUSTID IN (109833810,109833839,109833878,109833898,
								13924584,88557576,98754632) 
		group by winlostdate,custid
		HAVING sum(playercomm) <> 0

	/*UNION ALL
	--INSERT INTO DB06.bodb_Report.dbo.statement
	SELECT custid, accdate, SUM(totalamt) as totalamt, 'GP' AS transtype, 'Grand Prize' AS transdesc
	FROM (
			--SELECT b.custid, b.winlostdate AS accdate, SUM(bm.winlost - bm.stake) AS totalamt
			--FROM bettrans14 b WITH (NOLOCK)
			--	INNER JOIN bettransm14 bm WITH (NOLOCK)
			--		ON b.refno = bm.refno
			--WHERE b.bettype = 18000
			--	AND b.winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			--	AND bm.statuswinlost <> 0
			--GROUP BY b.winlostdate, b.custid
			--HAVING SUM(bm.winlost - bm.stake) <> 0

			--UNION ALL
			SELECT b.custid, b.winlostdate AS accdate, SUM(b.WinAmount) AS totalamt
			FROM dbo.PayoutTrans b WITH(NOLOCK) 
			WHERE b.winlostdate BETWEEN @min_winlostdate AND @max_winlostdate	
				  AND PayoutStatusId IN (4, 5)  ----- 'Completed', 'Expired'			
			GROUP BY b.winlostdate, b.custid
			HAVING SUM(b.WinAmount) <> 0
		) GP
	GROUP BY custid, accdate*/

		

	UNION ALL
	-- Agent - position & commission
	--INSERT INTO DB06.bodb_Report.dbo.statement
		select recommend,winlostdate accdate,sum(awinlost) totalamt,'POS' transtype, 'Position' transdesc
		from dbo.bettrans14 bettrans with (nolock)
		where bettype between 1 and 19999 and winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			AND recommend IN (98754632) 
		group by winlostdate,recommend
		HAVING sum(awinlost) <> 0
	UNION ALL
	--INSERT INTO DB06.bodb_Report.dbo.statement
		select recommend,winlostdate accdate,sum(comm-playercomm) totalamt,'COM' transtype, 'Commission' transdesc
		from dbo.bettrans14 bettrans  with (nolock)
		where bettype between 1 and 19999 and winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			AND recommend IN (98754632) 
		group by winlostdate,recommend
		HAVING sum(comm-playercomm) <> 0
	UNION ALL
	-- Master - position & commission
	--INSERT INTO DB06.bodb_Report.dbo.statement
		select mrecommend,winlostdate accdate,sum(mwinlost) totalamt,'POS' transtype, 'Position' transdesc
		from dbo.bettrans14 bettrans with (nolock)
		where bettype between 1 and 19999 and winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			AND mrecommend IN (88557576) 
		group by winlostdate,mrecommend
		HAVING sum(mwinlost) <> 0
	UNION ALL
	--INSERT INTO DB06.bodb_Report.dbo.statement
		select mrecommend,winlostdate accdate,sum(acomm-comm) totalamt,'COM' transtype, 'Commission' transdesc
		from dbo.bettrans14 bettrans with (nolock)
		where bettype between 1 and 19999 and winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			AND mrecommend IN (88557576) 
		group by winlostdate,mrecommend
		HAVING sum(acomm-comm) <> 0
	UNION ALL
	-- Super - position & commission
	--INSERT INTO DB06.bodb_Report.dbo.statement
		select srecommend,winlostdate accdate,sum(swinlost) totalamt,'POS' transtype, 'Position' transdesc
		from dbo.bettrans14 bettrans with (nolock)
		where bettype between 1 and 19999 and winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			AND srecommend IN (13924584) 
		group by winlostdate,srecommend
		HAVING sum(swinlost) <> 0
	UNION ALL
	--INSERT INTO DB06.bodb_Report.dbo.statement
		select srecommend,winlostdate accdate,sum(scomm-acomm) totalamt,'COM' transtype, 'Commission' transdesc
		from dbo.bettrans14 bettrans with (nolock)
		where bettype between 1 and 19999 and winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
			AND srecommend IN (13924584) 
		group by winlostdate,srecommend
		HAVING sum(scomm-acomm) <> 0

END
GO
