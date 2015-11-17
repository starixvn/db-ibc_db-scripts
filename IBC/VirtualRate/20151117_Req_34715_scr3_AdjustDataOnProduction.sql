/*
	Created: 20151111@Billy
	Task: Adjust data on Production environment (UM Time)
	DB: DBCUST.CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Execrep SP for adjusting Virtual Rate settings from old table [CustVirtualRate] to new table [CustVirtualSetting] --
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@custid		INT,
	@roldid		TINYINT,
	@target		VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @counter INT

	IF (@target = 'REPLICATED' AND @@SERVERNAME =  'DBCUST')	-- Run at all replicated servers
		RETURN
	IF (@target = 'DBCUST'	   AND @@SERVERNAME <> 'DBCUST')	-- Run at DBCUST only
		RETURN

	IF	(	SELECT	COUNT(1)
			FROM	sys.tables WITH(NOLOCK)
			WHERE	name IN ('CustVirtualRate', 'CustVirtualSetting', 'ProfileVirtualSetting', 'CustInfo')
		) <> 4
		RETURN

	IF @roldid = 4
	BEGIN
		SELECT @counter = (SELECT COUNT(1) FROM custInfo WHERE srecommend = @custid)

		WHILE @counter >= 0
		BEGIN
			UPDATE cvs
			SET bitmapVirtual = newdata.bitmapVirtual
			FROM	CustVirtualSetting AS cvs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN (
				SELECT custid, seqNo, bitmapVirtual, rowNumber
				FROM (
					SELECT	ci.custid,
							sn.seqNo,
							bv.bitmapVirtual,
							ROW_NUMBER() OVER(ORDER BY custid, seqNo) AS rowNumber
					FROM (
						SELECT ci.custid
						FROM custInfo AS ci WITH(NOLOCK)
						WHERE ci.srecommend = @custid
						AND [Enabled] = 1
					) ci
					CROSS APPLY (
						SELECT 1 AS seqNo
						UNION ALL
						SELECT 2 AS seqNo
					) sn
					CROSS APPLY (
						SELECT(dbo.f_TransferVirtualSetting(0x00, ci.custid, sn.seqNo)) AS bitmapVirtual
					) bv
				) data	
			) AS newdata
					ON	cvs.custid = newdata.custid
					AND cvs.seqNo = newdata.seqNo
					AND newdata.rowNumber BETWEEN @counter - 19999 AND @counter

			SET @counter = @counter - 20000
		END
	END
	ELSE IF @roldid = 3
	BEGIN
		SELECT @counter = (SELECT COUNT(1) FROM custInfo WHERE mrecommend = @custid)

		WHILE @counter >= 0
		BEGIN
			UPDATE cvs
			SET bitmapVirtual = newdata.bitmapVirtual
			FROM	CustVirtualSetting AS cvs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN (
				SELECT custid, seqNo, bitmapVirtual, rowNumber
				FROM (
					SELECT	ci.custid,
							sn.seqNo,
							bv.bitmapVirtual,
							ROW_NUMBER() OVER(ORDER BY custid, seqNo) AS rowNumber
					FROM (
						SELECT ci.custid
						FROM custInfo AS ci WITH(NOLOCK)
						WHERE ci.mrecommend = @custid
						AND [Enabled] = 1
					) ci
					CROSS APPLY (
						SELECT 1 AS seqNo
						UNION ALL
						SELECT 2 AS seqNo
					) sn
					CROSS APPLY (
						SELECT(dbo.f_TransferVirtualSetting(0x00, ci.custid, sn.seqNo)) AS bitmapVirtual
					) bv
				) data	
			) AS newdata
					ON	cvs.custid = newdata.custid
					AND cvs.seqNo = newdata.seqNo
					AND newdata.rowNumber BETWEEN @counter - 19999 AND @counter

			SET @counter = @counter - 20000
		END
	END
	ELSE IF @roldid = 2
	BEGIN
		SELECT @counter = (SELECT COUNT(1) FROM custInfo WHERE recommend = @custid)

		WHILE @counter >= 0
		BEGIN
			UPDATE cvs
			SET bitmapVirtual = newdata.bitmapVirtual
			FROM	CustVirtualSetting AS cvs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN (
				SELECT custid, seqNo, bitmapVirtual, rowNumber
				FROM (
					SELECT	ci.custid,
							sn.seqNo,
							bv.bitmapVirtual,
							ROW_NUMBER() OVER(ORDER BY custid, seqNo) AS rowNumber
					FROM (
						SELECT ci.custid
						FROM custInfo AS ci WITH(NOLOCK)
						WHERE ci.recommend = @custid
						AND [Enabled] = 1
					) ci
					CROSS APPLY (
						SELECT 1 AS seqNo
						UNION ALL
						SELECT 2 AS seqNo
					) sn
					CROSS APPLY (
						SELECT(dbo.f_TransferVirtualSetting(0x00, ci.custid, sn.seqNo)) AS bitmapVirtual
					) bv
				) data	
			) AS newdata
					ON	cvs.custid = newdata.custid
					AND cvs.seqNo = newdata.seqNo
					AND newdata.rowNumber BETWEEN @counter - 19999 AND @counter

			SET @counter = @counter - 20000
		END
	END
	ELSE IF @roldid = 1
	BEGIN
		UPDATE cvs
		SET bitmapVirtual = newdata.bitmapVirtual
		FROM	CustVirtualSetting AS cvs WITH(ROWLOCK,UPDLOCK)
		CROSS APPLY (
			SELECT(dbo.f_TransferVirtualSetting(cvs.bitmapVirtual, cvs.custid, cvs.seqNo)) AS bitmapVirtual
		) newdata
		WHERE cvs.custid = @custid
	END
END
GO


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON REPLICATED SERVER --
-----------------------------------------------------------

-- Customers that need to adjust data --
CREATE TABLE	#customers (
					custid INT,
					roleid TINYINT,
					isfinished BIT DEFAULT(0)
				)

DECLARE @custid INT,
		@roleid TINYINT

INSERT INTO	#customers (custid)
SELECT custid, roleid
FROM custInfo WITH(NOLOCK)
WHERE custid IN (
	SELECT DISTINCT custid
	FROM DB06.bodb_CustHistory.dbo.CustVirtualRate_History WITH(NOLOCK)
	WHERE UpdateTime >= '2015-11-15 00:00:00.000'						-- Correct this time with the time begin running import data script
)

-- Import virtual setting from old structure to new structure for selected customer lines --
WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #customers
	SET		isfinished = 1,
			@custid = custid,
			@roleid = roleid
	WHERE	isfinished = 0

	IF @@ROWCOUNT = 0
		BREAK

	EXECUTE Acc_CustSetting3rd_19 @custid, @roleid, 'REPLICATED'

	WAITFOR DELAY '00:00:00.280'
END
GO


-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Customers that need to adjust data --
CREATE TABLE	#customers (
					custid INT,
					roleid TINYINT,
					isfinished BIT DEFAULT(0)
				)

DECLARE @custid INT,
		@roleid TINYINT

INSERT INTO	#customers (custid)
SELECT custid, roleid
FROM custInfo WITH(NOLOCK)
WHERE custid IN (
	SELECT DISTINCT custid
	FROM DB06.bodb_CustHistory.dbo.CustVirtualRate_History WITH(NOLOCK)
	WHERE UpdateTime >= '2015-11-15 00:00:00.000'						-- Correct this time with the time begin running import data script
)

-- Import virtual setting from old structure to new structure for selected customer lines --
WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #customers
	SET		isfinished = 1,
			@custid = custid,
			@roleid = roleid
	WHERE	isfinished = 0

	IF @@ROWCOUNT = 0
		BREAK

	EXECUTE Acc_CustSetting3rd_19 @custid, @roleid, 'DBCUST'

	WAITFOR DELAY '00:00:00.280'
END
GO