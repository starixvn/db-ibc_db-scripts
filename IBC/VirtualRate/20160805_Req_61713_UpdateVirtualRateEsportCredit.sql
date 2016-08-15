/*
	Created: 20160805@Winnie
	Task: Modify Virtual Rate data following new requirements - [Redmine: #61713]
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
	
	IF dbo.f_CheckRepTable('CustVirtualSetting') = 0 RETURN
	IF dbo.f_CheckRepTable('custInfo') = 0 RETURN
	
	UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid AND	ci.srecommend = @srecommend
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=1 and islive=0
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=1 and pv.islive=0
    WHERE cvs.custid <= @maxCustID;
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid AND	ci.srecommend = @srecommend
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=1 and islive=1
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=1 and pv.islive=1
    WHERE cvs.custid <= @maxCustID;
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid AND	ci.srecommend = @srecommend
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=2 and islive=0
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=2 and pv.islive=0
    WHERE cvs.custid <= @maxCustID;
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid AND	ci.srecommend = @srecommend
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=2 and islive=1
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=2 and pv.islive=1
    WHERE cvs.custid <= @maxCustID;
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid AND	ci.srecommend = @srecommend
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=3 and islive=0
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=3 and pv.islive=0
    WHERE cvs.custid <= @maxCustID;
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid AND	ci.srecommend = @srecommend
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=3 and islive=1
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=3 and pv.islive=1
    WHERE cvs.custid <= @maxCustID;
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid AND	ci.srecommend = @srecommend
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=20 and islive=0
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=20 and pv.islive=0
    WHERE cvs.custid <= @maxCustID;
    
    UPDATE cvs 
	SET bitmapVirtual=CONVERT(binary(64), STUFF(bitmapVirtual, 1+((pv.profileID-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((pvs.profileID-1)%64), 1)))
	FROM        CustVirtualSetting    AS cvs WITH(NOLOCK)
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid AND	ci.srecommend = @srecommend
    INNER JOIN  ProfileVirtualSetting       AS pvs WITH(NOLOCK)   
            ON  cvs.seqNo = pvs.seqNo   AND sporttype=99 AND bettype=20 and islive=1
    INNER JOIN  ProfileVirtualSetting       AS pv WITH(NOLOCK)   
            ON  cvs.seqNo = pv.seqNo   AND pv.sporttype=43 AND pv.bettype=20 and pv.islive=1
    WHERE cvs.custid <= @maxCustID;
	
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