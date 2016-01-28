/*
	Created: 20160127@Billy
	Task: Modify Virtual Rate data following new requirements
	DB: DBCUST/CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Execrep SP for modify Virtual Rate settings --
ALTER PROCEDURE	dbo.Acc_CustSetting3rd_19
					@srecommend	INT
				,	@maxCustID	INT
				,	@target		VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON;

	IF (@target = 'REPLICATED' AND @@SERVERNAME =  'DBCUST')	-- Run at all replicated servers
		RETURN;
	IF (@target = 'DBCUST'	   AND @@SERVERNAME <> 'DBCUST')	-- Run at DBCUST only
		RETURN;
	
	IF	(	SELECT	COUNT(1)
			FROM	sys.tables WITH(NOLOCK)
			WHERE	name IN ('CustVirtualSetting', 'custInfo')
		) <> 2
		RETURN;
	
	UPDATE	cvs WITH(ROWLOCK,UPDLOCK)
	SET		cvs.bitmapVirtual =	CONVERT(
									BINARY(64)
								,	REPLACE(
										REPLACE(	cvs.bitmapVirtual
												,	CAST(CAST(50 AS BINARY(1)) AS VARCHAR)	-- Virtual Rate -50%
												,	CAST(CAST(30 AS BINARY(1)) AS VARCHAR)	-- replaced with Virtual Rate -70%
												)
									,	CAST(CAST(40 AS BINARY(1)) AS VARCHAR)	-- Virtual Rate -60%
									,	CAST(CAST(30 AS BINARY(1)) AS VARCHAR)	-- replaced with Virtual Rate -70%
									)
								)
	FROM		dbo.CustVirtualSetting AS cvs
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK)
			ON	ci.custid = cvs.custid
			AND	ci.srecommend = @srecommend
	WHERE	cvs.bitmapVirtual LIKE '%[' + CAST(CAST(50 AS BINARY(1)) AS VARCHAR) + CAST(CAST(40 AS BINARY(1)) AS VARCHAR) + ']%'
		AND	cvs.custid <= @maxCustID;
	
END;
GO


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON REPLICATED SERVER --
-----------------------------------------------------------

-- Select super lines for importing data --
DECLARE	@maxCustID	INT = xxxx;

CREATE TABLE	#supers (
					CustID		INT
				,	isFinished	BIT	DEFAULT(0)
				,	PRIMARY KEY CLUSTERED (CustID)
				);

INSERT INTO #supers(CustID)
SELECT	ci.custid
FROM	dbo.custInfo AS ci WITH(NOLOCK)
WHERE	ci.roleid = 4
	AND	ci.custid <= @maxCustID
	AND	NOT EXISTS (
			SELECT	TOP(1) 1
			FROM	dbo.Dep_CustSuper AS dcs WITH(NOLOCK)
			WHERE	dcs.custid = ci.custid
		);
GO

-- Modify virtual rate settings for credit super lines --
DECLARE	@srecommend	INT
	,	@maxCustID	INT = xxxx;

WHILE (0 = 0)
BEGIN
    UPDATE TOP(1) #supers
	SET		isFinished = 1,
			@srecommend = CustID
	WHERE	isFinished = 0;

	IF	@@ROWCOUNT = 0
		BREAK;

	EXECUTE	dbo.Acc_CustSetting3rd_19
				@srecommend = @srecommend
			,	@maxCustID = @maxCustID
			,	@target = 'REPLICATED';

	WAITFOR DELAY '00:00:00.280';	
END;
GO


-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Select super lines for importing data --
DECLARE	@maxCustID	INT = xxxx;

CREATE TABLE	#supers (
					CustID		INT
				,	isFinished	BIT	DEFAULT(0)
				,	PRIMARY KEY CLUSTERED (CustID)
				);
				
INSERT INTO #supers (CustID)
SELECT	ci.custid
FROM	dbo.custInfo AS ci WITH(NOLOCK)
WHERE	ci.roleid = 4
	AND	ci.custid <= @maxCustID
	AND	NOT EXISTS (
			SELECT	TOP(1) 1
			FROM	dbo.Dep_CustSuper AS dcs WITH(NOLOCK)
			WHERE	dcs.custid = ci.custid
		);
GO

-- Modify virtual rate settings for credit super lines --
DECLARE	@srecommend	INT
	,	@maxCustID	INT = xxxx;

WHILE (0 = 0)
BEGIN
    UPDATE TOP(1) #supers
	SET		isFinished = 1,
			@srecommend = CustID
	WHERE	isFinished = 0;

	IF	@@ROWCOUNT = 0
		BREAK;

	EXECUTE	dbo.Acc_CustSetting3rd_19
				@srecommend = @srecommend
			,	@maxCustID = @maxCustID
			,	@target = 'DBCUST';

	WAITFOR DELAY '00:00:00.280';	
END;
GO

--DROP TABLE #supers