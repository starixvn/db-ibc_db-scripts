
/*
	Created: Winnie	
	Task:  Update ClosedReason on CustLoginInfo_Member
	DB: DBCUST/CustDB, DB06/bodb02
	Date: 20170523
*/ 
ALTER PROCEDURE [dbo].Acc_CustSetting3rd_19	
	@target VARCHAR(20)	
	,@ids VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only

	IF NOT (dbo.f_CheckRepTable('CustLoginInfo') = 1 AND  dbo.f_CheckRepTable('CustLoginInfo_Member') = 1 )
		RETURN	
	
	DECLARE @string VARCHAR(MAX), @splitter CHAR(1), @xml XML
	SELECT @splitter = ',', @string = @ids

	SET @xml = N'<root><r i=''' + REPLACE(@string, @splitter, '''/><r i=''') + '''/></root>'

	--Create temp table containing all accounts belong to super, exclude fincance account
	CREATE TABLE #tblCust (custid INT)	
	INSERT INTO #tblCust(custid)
	SELECT r.value('./@i','INT')
	FROM @xml.nodes('//root/r') AS RECORDS(r)

	UPDATE c
	SET   c.ClosedReason=ISNULL(t.ClosedReason,0)
	FROM CustLoginInfo_Member c WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tblCust t WITH(NOLOCK) ON c.CustID=t.CustID
		

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------

	CREATE TABLE #temp(custid INT PRIMARY KEY, isfinished BIT DEFAULT(0))
	INSERT INTO #temp(custid)
	SELECT custid
	FROM TempClosedReasonMember WITH(NOLOCK)		

		DECLARE @ids VARCHAR(MAX), @rowcnt INT
		WHILE (1=1)
		BEGIN
			SELECT @ids = ''
	
			UPDATE TOP (10000) #temp
			SET @ids = @ids + CASE @ids WHEN '' THEN '' ELSE ',' END + CAST(custid AS VARCHAR(12))
				,isfinished = 1
			FROM #temp
			WHERE isfinished = 0

			SELECT @rowcnt = @@rowcount	
			
			EXEC Acc_CustSetting3rd_19 @ids = @ids,@target = 'REPLICATED'

			IF @rowcnt < 10000 BREAK

			WAITFOR DELAY '00:00:00.28'
		END
	


-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
	CREATE TABLE #temp(custid INT PRIMARY KEY, isfinished BIT DEFAULT(0))
	INSERT INTO #temp(custid)
	SELECT custid
	FROM TempClosedReasonMember WITH(NOLOCK)		

		DECLARE @ids VARCHAR(MAX), @rowcnt INT
		WHILE (1=1)
		BEGIN
			SELECT @ids = ''
	
			UPDATE TOP (10000) #temp
			SET @ids = @ids + CASE @ids WHEN '' THEN '' ELSE ',' END + CAST(custid AS VARCHAR(12))
				,isfinished = 1
			FROM #temp
			WHERE isfinished = 0

			SELECT @rowcnt = @@rowcount	
			
			EXEC Acc_CustSetting3rd_19 @ids = @ids,@target = 'DBCUST'

			IF @rowcnt < 10000 BREAK

			WAITFOR DELAY '00:00:00.28'
		END

