ALTER PROCEDURE dbo.DBA_CustSetting_UpdSettingModAndDelIndiviSetting
AS
BEGIN
	DECLARE @maxcustid INT
		,@i INT
		,@step INT=100000
	DECLARE @ptsettingNumber INT

	SELECT @ptsettingNumber = COUNT(1)
	FROM ProductSettingDetail
	WHERE SettingType = 1

	SELECT @maxcustid = MAX(CustID)
	FROM CustSettingMode3rd

	SELECT @i = MIN(CustID)
	FROM CustSettingMode3rd

	CREATE TABLE #tt (custid INT)

	WHILE (@i < = @maxcustid)
	BEGIN
		INSERT INTO #tt
		SELECT cm.CustID
		FROM CustSettingMode3rd cm(NOLOCK)
		INNER JOIN custInfo c(NOLOCK) ON c.custid = cm.CustID
		INNER JOIN CustPTSetting3rd_Member mb(NOLOCK) ON cm.CustID = mb.CustID
		INNER JOIN CustPTGroupSetting3rd_Member gp(NOLOCK) ON gp.AgentID = c.recommend
			AND gp.SportType = mb.SportType
			AND gp.BetType = mb.BetType
			AND gp.IsLive = mb.IsLive
			AND gp.SuperPT = mb.SuperPT
			AND gp.MasterPT = mb.MasterPT
			AND gp.AgentPT = mb.AgentPT
			AND gp.IsAutoSuperPT = mb.IsAutoSuperPT
			AND gp.AutoSuperPT = mb.AutoSuperPT
			AND gp.IsAutoMasterPT = mb.IsAutoMasterPT
			AND gp.AutoMasterPT = mb.AutoMasterPT
		WHERE IsGrouped = 0
			AND cm.CustID BETWEEN @i + 1
				AND @i + @step
		GROUP BY cm.CustID
		HAVING COUNT(1) = @ptsettingNumber

		UPDATE CustSettingMode3rd
		SET IsGrouped = 1
		WHERE CustID IN (
				SELECT CustID
				FROM #tt
				)

		DELETE CustPTSetting3rd_Member
		WHERE CustID IN (
				SELECT CustID
				FROM #tt
				)

		TRUNCATE TABLE #tt

		SET @i = @i + @step
	END

	DROP TABLE #tt

END

