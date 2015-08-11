ALTER PROCEDURE dbo.DBA_CustSetting_EstablishGroupSettings
AS
BEGIN
	SET NOCOUNT ON 

	DECLARE @CustId INT, @SportType SMALLINT, @count INT = 0, 
	@countedLine int = 0 , @maxcustid int, @i int
	,@step INT = 50000

	CREATE TABLE #temp(recommend INT, custid INT, allsettingvalue VARCHAR(MAX), MemberCount INT)
	CREATE TABLE #temp2 (recommend INT, custid INT, MemberCount INT)
	CREATE TABLE #temp3 (recommend INT, custid INT)


	--Get all member
	SELECT @maxcustid = MAX(custid)  from dbo.CustPTSetting3rd_Member 
	SELECT @i = MIN(custid) from dbo.CustPTSetting3rd_Member 
	WHILE (@i< = @maxcustid)
	BEGIN
		INSERT INTO #temp
		SELECT 
		  ci.recommend,
		  cs.custid,
		  STUFF((
			SELECT 
			+ ', ' +CAST([SuperPT] AS VARCHAR(MAX)),
			+ ', ' +CAST([MasterPT] AS VARCHAR(MAX)),
			+ ', ' +CAST([AgentPT] AS VARCHAR(MAX)),
			+ ', ' +CAST([IsAutoMasterPT] AS VARCHAR(MAX)),
			+ ', ' +CAST([AutoMasterPT] AS VARCHAR(MAX)),
			+ ', ' +CAST([IsAutoSuperPT] AS VARCHAR(MAX)),
			+ ', ' +CAST([AutoSuperPT] AS VARCHAR(MAX))
			FROM dbo.CustPTSetting3rd_Member 
			WHERE (custid = cs.custid)
			ORDER BY custid,sporttype,bettype
			FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
		  ,1,2,'') AS allsettingvalue
		  ,1
		FROM dbo.CustPTSetting3rd_Member cs
			JOIN dbo.CustSettingMode3rd md ON cs.custid=md.custid
			JOIN dbo.custInfo ci ON ci.custid=cs.CustID
			WHERE md.custid BETWEEN @i AND @i+ @step
		GROUP BY ci.recommend,cs.custid

		
		SET @i = @i + @step
		
	END


	--Sum grouped member at the final step
	INSERT INTO #temp2(recommend,custid,MemberCount)
	SELECT tp.recommend,MAX(tp.custid),SUM(tp.MemberCount)
	FROM #temp tp
	GROUP BY tp.recommend,tp.allsettingvalue


	--Get representative CustID for each Group Setting
	INSERT INTO #temp3
	SELECT main.recommend,MAX(main.custid)
	FROM #temp2 main
	WHERE main.MemberCount=(SELECT MAX(MemberCount) FROM #temp2 WHERE main.recommend=recommend)
	GROUP BY main.recommend
       
       

	--INSERT GROUP SETTING VALUE
	SELECT @maxcustid = MAX(recommend)  from #temp3 
	SELECT @i = MIN(recommend) from #temp3 
	SELECT @step=200000
	WHILE (@i< = @maxcustid)
	BEGIN
		UPDATE main WITH(ROWLOCK, UPDLOCK)
		SET main.[SuperPT] = mb.[SuperPT]
		   ,main.[MasterPT] = mb.[MasterPT]
		   ,main.[AgentPT] = mb.[IsAutoMasterPT]
		   ,main.[IsAutoMasterPT] = mb.[IsAutoMasterPT]
		   ,main.[AutoMasterPT] = mb.[AutoMasterPT]
		   ,main.[IsAutoSuperPT] = mb.[IsAutoSuperPT]
		   ,main.[AutoSuperPT] = mb.[AutoSuperPT]
		FROM [dbo].[CustPTGroupSetting3rd_Member] main 
		INNER JOIN #temp3 tp ON main.AgentID = tp.recommend
		INNER JOIN dbo.CustPTSetting3rd_Member mb
		 ON tp.custid=mb.CustID AND mb.Sporttype = main.Sporttype AND  mb.[BetType] = main.[BetType] AND mb.[IsLive] = main.[IsLive]
		WHERE tp.recommend BETWEEN @i + 1 AND @i+ @step
		AND (
			main.[SuperPT] <> mb.[SuperPT]
		   OR main.[MasterPT] <> mb.[MasterPT]
		   OR main.[AgentPT] <> mb.[IsAutoMasterPT]
		   OR main.[IsAutoMasterPT] <> mb.[IsAutoMasterPT]
		   OR main.[AutoMasterPT] <> mb.[AutoMasterPT]
		   OR main.[IsAutoSuperPT] <> mb.[IsAutoSuperPT]
		   OR main.[AutoSuperPT] <> mb.[AutoSuperPT]
		)
		
		SET @i = @i + @step
	END

	 
	DROP TABLE #temp
	DROP TABLE #temp2
	DROP TABLE #temp3

END
