DECLARE @superUsername VARCHAR(30) = 'SuperTestCNL'
DECLARE @SportTypeGroups VARCHAR(100) = ''

BEGIN
	-- Get Member List --
	DECLARE @srecommend INT
	SELECT  @srecommend = custid FROM CustDB.dbo.Customer WITH (NOLOCK) WHERE username = @superUsername AND roleid = 4

	IF @@ROWCOUNT = 0
	BEGIN
		SELECT 'Invalid Super Name'
		RETURN
	END

	DECLARE @tblMember TABLE (srecommend INT, mrecommend INT, recommend INT, custid INT, username VARCHAR(50), currency INT, currencyName VARCHAR(50), actualrate FLOAT)
	-- get top 2 member each recommend
	INSERT INTO @tblMember (srecommend, mrecommend, recommend, custid, username, currency, currencyName, actualrate)
	SELECT srecommend, mrecommend, recommend, custid, username, currency, currencyName, actualrate
	FROM (
		SELECT srecommend, mrecommend, recommend, custid, username, c.currency, e.currency as currencyName, actualrate, ROW_NUMBER() OVER(PARTITION BY recommend ORDER BY custid) AS RN
		FROM CustDB.dbo.Customer c WITH (NOLOCK)
			INNER JOIN bodb02.dbo.exchange e WITH (NOLOCK) ON c.currency = e.exchangeid
		WHERE srecommend = @srecommend AND roleid = 1
	) AS member
	WHERE RN <= 2

	IF @@ROWCOUNT = 0
	BEGIN
		SELECT 'This Super not have member'
		RETURN
	END
	-- End Get Member List --

	-- Get data --
	DECLARE @tblSportType TABLE (SportType INT)
	INSERT INTO @tblSportType (SportType)
	SELECT DISTINCT SportType FROM dbo.CS_SportBettypeMatrix WITH (NOLOCK)
	WHERE @SportTypeGroups = '' OR ',' + @SportTypeGroups + ',' LIKE '%,' + CONVERT(VARCHAR(10), SportTypeGroup) + ',%'

	DECLARE @tblBettrans TABLE (transid BIGINT)
	INSERT INTO @tblBettrans (transid)
	SELECT transid
	FROM (
		SELECT b.transid, ROW_NUMBER() OVER(PARTITION BY m.sporttype, b.bettype, b.status, b.betteam ORDER BY b.transid ASC) AS rn
		FROM dbo.bettrans b WITH (NOLOCK)
			INNER JOIN dbo.match m WITH (NOLOCK) ON b.matchid = m.matchid
			INNER JOIN @tblSportType s ON s.SportType = m.sporttype
	) AS A
	WHERE rn = 1

	INSERT INTO @tblBettrans (transid)
	SELECT transid
	FROM (
		SELECT b.transid, ROW_NUMBER() OVER(PARTITION BY l.sporttype, b.bettype, b.status, b.betteam ORDER BY b.transid ASC) AS rn
		FROM dbo.bettrans b WITH (NOLOCK)
			INNER JOIN dbo.outright m WITH (NOLOCK) ON b.matchid = m.orid
			INNER JOIN dbo.League l WITH (NOLOCK) ON m.leagueid = l.leagueid
			INNER JOIN @tblSportType s ON s.SportType = l.sporttype
		WHERE b.bettype = 10
	) AS A
	WHERE rn = 1
	
	-- Insert bettrans
	INSERT INTO bodb02.dbo.bettrans
	(
		custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,
		apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,
		liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,
		matchid,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,
		sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,
		currency2,balance,SecAcceptFlag,transid2,RecommDate,ExtraInfo,WalletType,BonusID,RefCode
	)
	SELECT
		m.custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,
		apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,
		liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,m.actualrate,
		matchid,m.recommend,m.mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,m.currency,ip,transdesc,
		sdiscount,scomm,spositiontaking,swinlost,m.srecommend,m.Username,m.CurrencyName,m.actualrate,oddstype,statusID,
		currency2,balance,SecAcceptFlag,transid2,RecommDate,ExtraInfo,WalletType,BonusID,RefCode
	FROM bodb02.dbo.bettrans b WITH (NOLOCK)
		INNER JOIN @tblBettrans t ON b.transid = t.transid
		CROSS JOIN @tblMember m
END