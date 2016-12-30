/*
	Created: 20161230@Elodie
	Task: Fix comission of Macau Game on member level
	DB: DBCUST/CustDB
*/

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@ids VARCHAR(MAX)
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Agent') = 0 RETURN

	DECLARE @string VARCHAR(MAX), @splitter CHAR(1), @xml XML
	SELECT @splitter = ',', @string = @ids

	SET @xml = N'<root><r i=''' + REPLACE(@string, @splitter, '''/><r i=''') + '''/></root>'

	--Create temp table containing all accounts belong to super, exclude fincance account
	CREATE TABLE #tblCust (custid INT)	
	INSERT INTO #tblCust(custid)
	SELECT r.value('./@i','INT')
	FROM @xml.nodes('//root/r') AS RECORDS(r)

	UPDATE cs
	SET cs.SuperDiscount = css.Discount,
		cs.MasterDiscount = csm.Discount,
		cs.AgentDiscount = csa.Discount
	FROM dbo.CustDiscount3rd_Member cs WITH (ROWLOCK, UPDLOCK)
		INNER JOIN dbo.custInfo ci WITH (NOLOCK) ON ci.custid = cs.CustID 
		INNER JOIN #tblCust c WITH (NOLOCK) ON c.custid = cs.CustID 
		INNER JOIN dbo.CustDiscount3rd_Agent css WITH (NOLOCK) ON ci.srecommend = css.CustID AND cs.SportType = css.SportType AND cs.BetType = css.BetType
		INNER JOIN dbo.CustDiscount3rd_Agent csm WITH (NOLOCK) ON ci.mrecommend = csm.CustID AND cs.SportType = csm.SportType AND cs.BetType = csm.BetType
		INNER JOIN dbo.CustDiscount3rd_Agent csa WITH (NOLOCK) ON ci.recommend = csa.CustID AND cs.SportType = csa.SportType AND cs.BetType = csa.BetType
	WHERE cs.SportType = 212 AND cs.BetType = 4001
		AND (cs.SuperDiscount <> css.Discount OR cs.MasterDiscount <> csm.Discount OR cs.AgentDiscount <> csa.Discount)
		AND ci.Enabled = 1
		AND ci.custid <= @maxcustid
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
DECLARE @ids VARCHAR(MAX), @rowcnt INT, @maxcustid INT

CREATE TABLE #temp(custid INT PRIMARY KEY, isfinished BIT DEFAULT(0))
INSERT INTO #temp(custid)
SELECT ci.custid
FROM dbo.CustDiscount3rd_Member cs WITH (NOLOCK)
	INNER JOIN dbo.custInfo ci WITH (NOLOCK) ON ci.custid = cs.CustID 
	INNER JOIN dbo.CustDiscount3rd_Agent css WITH (NOLOCK) ON ci.srecommend = css.CustID AND cs.SportType = css.SportType AND cs.BetType = css.BetType
	INNER JOIN dbo.CustDiscount3rd_Agent csm WITH (NOLOCK) ON ci.mrecommend = csm.CustID AND cs.SportType = csm.SportType AND cs.BetType = csm.BetType
	INNER JOIN dbo.CustDiscount3rd_Agent csa WITH (NOLOCK) ON ci.recommend = csa.CustID AND cs.SportType = csa.SportType AND cs.BetType = csa.BetType
WHERE cs.SportType = 212 AND cs.BetType = 4001
	AND (cs.SuperDiscount <> css.Discount OR cs.MasterDiscount <> csm.Discount OR cs.AgentDiscount <> csa.Discount)
	AND ci.Enabled = 1
	AND ci.custid <= @maxcustid

WHILE (1=1)
BEGIN
	SELECT @ids = ''
	
	UPDATE TOP (10000) #temp
	SET @ids = @ids + CASE @ids WHEN '' THEN '' ELSE ',' END + CAST(custid AS VARCHAR(12))
		,isfinished = 1
	FROM #temp
	WHERE isfinished = 0

	SELECT @rowcnt = @@rowcount	
				 
	EXEC Acc_DynamicCustSetting3rd_09 
		@ids = @ids, 
		@maxcustid = @maxcustid, 
		@target = 'REPLICATED'

	IF @rowcnt < 10000 BREAK

	WAITFOR DELAY '00:00:00.18'
END	
GO

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
DECLARE @ids VARCHAR(MAX), @rowcnt INT, @maxcustid INT

CREATE TABLE #temp(custid INT PRIMARY KEY, isfinished BIT DEFAULT(0))
INSERT INTO #temp(custid)
SELECT ci.custid
FROM dbo.CustDiscount3rd_Member cs WITH (NOLOCK)
	INNER JOIN dbo.custInfo ci WITH (NOLOCK) ON ci.custid = cs.CustID 
	INNER JOIN dbo.CustDiscount3rd_Agent css WITH (NOLOCK) ON ci.srecommend = css.CustID AND cs.SportType = css.SportType AND cs.BetType = css.BetType
	INNER JOIN dbo.CustDiscount3rd_Agent csm WITH (NOLOCK) ON ci.mrecommend = csm.CustID AND cs.SportType = csm.SportType AND cs.BetType = csm.BetType
	INNER JOIN dbo.CustDiscount3rd_Agent csa WITH (NOLOCK) ON ci.recommend = csa.CustID AND cs.SportType = csa.SportType AND cs.BetType = csa.BetType
WHERE cs.SportType = 212 AND cs.BetType = 4001
	AND (cs.SuperDiscount <> css.Discount OR cs.MasterDiscount <> csm.Discount OR cs.AgentDiscount <> csa.Discount)
	AND ci.Enabled = 1
	AND ci.custid <= @maxcustid

WHILE (1=1)
BEGIN
	SELECT @ids = ''
	
	UPDATE TOP (10000) #temp
	SET @ids = @ids + CASE @ids WHEN '' THEN '' ELSE ',' END + CAST(custid AS VARCHAR(12))
		,isfinished = 1
	FROM #temp
	WHERE isfinished = 0

	SELECT @rowcnt = @@rowcount	
				 
	EXEC Acc_DynamicCustSetting3rd_09 
		@ids = @ids, 
		@maxcustid = @maxcustid, 
		@target = 'DBCUST'

	IF @rowcnt < 10000 BREAK

	WAITFOR DELAY '00:00:00.18'
END		