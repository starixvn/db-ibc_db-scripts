USE [bodb_Archive]
GO

ALTER PROCEDURE [dbo].[DBA_BalanceUp_BK]
	@Match3rdId INT,
	@transIds VARCHAR(MAX),
	@translogIds VARCHAR(MAX),
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg VARCHAR(2000) = '' OUTPUT
AS

BEGIN
	SET NOCOUNT ON

	IF NOT EXISTS (SELECT 1 FROM dbo.Match3rd_bk WITH (NOLOCK) WHERE Match3rdId = @Match3rdId)
	BEGIN
		INSERT INTO dbo.Match3rd_bk
		(
			Match3rdId, League3rdId, HomeId, AwayId, EventDate, SportType, VendorMatchId, MatchNo, HasLive,
			EventStatus, VendorEventStatus, CreateTime, UpdateTime
		)
		SELECT
			Match3rdId, League3rdId, HomeId, AwayId, EventDate, SportType, VendorMatchId, MatchNo, HasLive,
			'Completed', VendorEventStatus, CreateTime, UpdateTime
		FROM bodb02.dbo.Match3rd WITH (NOLOCK)
		WHERE Match3rdId = @Match3rdId
	END

	INSERT INTO dbo.translog_bk
	(
		[translogid],[custid],[transdate],[odds],[stake],[status],[apositiontaking],[mpositiontaking],[tpositiontaking],[spositiontaking],
		[playerdiscount],[discount],[adiscount],[sdiscount],[creator],[winlostdate],[betfrom],[virtualrate],[actualrate],[actual_stake],
		[currency],[CurrencyName],[recommend],[mrecommend],[srecommend],[ip],[statusID],[balance],[Username],[transdesc],
		[productID],[gameID],[eventID],[vendorID],[Gameid3rd],[Tranid3rd],[liveindicator],[custom1],[custom2],[custom3]
	)
	SELECT
		[translogid],[custid],[transdate],[odds],[stake],[status],[apositiontaking],[mpositiontaking],[tpositiontaking],[spositiontaking],
		[playerdiscount],[discount],[adiscount],[sdiscount],[creator],[winlostdate],[betfrom],[virtualrate],[actualrate],[actual_stake],
		[currency],[CurrencyName],[recommend],[mrecommend],[srecommend],[ip],[statusID],[balance],[Username],[transdesc],
		[productID],[gameID],[eventID],[vendorID],[Gameid3rd],[Tranid3rd],[liveindicator],[custom1],[custom2],[custom3]
	FROM bodb02.dbo.translog WITH (NOLOCK)
	WHERE CHARINDEX(',' + CONVERT(VARCHAR(20), translogid) + ',', ',' + @translogIds + ',') > 0

	INSERT INTO dbo.bettrans_bk
	(
		[transid],[custid],[transdate],[oddsid],[hdp1],[odds],[stake],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking],
		[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno],
		[comstatus],[winlostdate],[betfrom],[betcheck],[checktime],[actualrate],[matchid],[recommend],[mrecommend],[ruben],[betid],[statuswinlost],
		[bettype],[betdaqid],[actual_stake],[currency],[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],[srecommend],
		[virtualrate],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[oddstype]
	)
	SELECT
		[transid],[custid],[transdate],[oddsid],[hdp1],[odds],[stake],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking],
		[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno],
		[comstatus],[winlostdate],[betfrom],[betcheck],[checktime],[actualrate],[matchid],[recommend],[mrecommend],[ruben],[betid],[statuswinlost],
		[bettype],[betdaqid],[actual_stake],[currency],[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],[srecommend],
		[virtualrate],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[oddstype]
	FROM bodb02.dbo.bettrans WITH (NOLOCK)
	WHERE CHARINDEX(',' + CONVERT(VARCHAR(20), transid) + ',', ',' + @transIds + ',') > 0

	IF @@ROWCOUNT = 0
	BEGIN
		SELECT @ErrCode = 100,
				@ErrMsg = 'No row inserted'
	END
END
GO