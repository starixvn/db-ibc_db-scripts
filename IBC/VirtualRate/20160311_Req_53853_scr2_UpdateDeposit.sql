/*
	Created: 20160311@Billy
	Task: Modify Virtual Rate data following new requirements - [Redmine: #53853]
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
										cvs.bitmapVirtual
									,	CAST(CAST(10 AS BINARY(1)) AS VARCHAR)	-- Virtual Rate -90%
									,	CAST(CAST(20 AS BINARY(1)) AS VARCHAR)	-- replaced with Virtual Rate -80%
									)
								)
	FROM		dbo.CustVirtualSetting AS cvs
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK)
			ON	ci.custid = cvs.custid
			AND	ci.srecommend = @srecommend
	WHERE	cvs.bitmapVirtual LIKE '%[' + CAST(CAST(10 AS BINARY(1)) AS VARCHAR) + ']%'	-- Update rows that containt Virtual Rate -90% only
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

INSERT INTO #supers (CustID)
SELECT	ci.custid
FROM		dbo.custInfo AS ci WITH(NOLOCK)
INNER JOIN	dbo.Dep_CustSuper AS dcs WITH(NOLOCK)
		ON	dcs.custid = ci.CustID
WHERE	ci.roleid = 4
	AND	ci.custid <= @maxCustID;
GO

-- Modify virtual rate settings for deposit super lines --
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
FROM		dbo.custInfo AS ci WITH(NOLOCK)
INNER JOIN	dbo.Dep_CustSuper AS dcs WITH(NOLOCK)
		ON	dcs.custid = ci.CustID
WHERE	ci.roleid = 4
	AND	ci.custid <= @maxCustID;
GO

-- Modify virtual rate settings for deposit super lines --
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