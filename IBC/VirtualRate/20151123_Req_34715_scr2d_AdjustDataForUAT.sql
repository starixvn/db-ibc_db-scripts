/*
	Created: 20151124@Billy
	Task: Adjust data on UAT environment (Non-UM Time)
	DB: DBCUST.CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Execrep SP for importing Virtual Rate settings from old table [CustVirtualRate] to new table [CustVirtualSetting] --
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend	INT,
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

	SELECT @counter = (SELECT COUNT(1) FROM custInfo WHERE srecommend = @srecommend) * 2

	WHILE @counter >= 0
	BEGIN
		INSERT INTO CustVirtualSetting(custid, seqNo, bitmapVirtual)
		SELECT custid, seqNo, bitmapVirtual
		FROM (
			SELECT	ci.custid,
					sn.seqNo,
					bv.bitmapVirtual,
					ROW_NUMBER() OVER(ORDER BY custid, seqNo) AS rowNumber
			FROM (
				SELECT ci.custid
				FROM custInfo AS ci WITH(NOLOCK)
				WHERE ci.srecommend = @srecommend
				AND [Enabled] = 1
				AND ci.custid NOT IN (
					SELECT custid FROM CustVirtualSetting WITH(NOLOCK)
				)
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
		WHERE rowNumber BETWEEN @counter - 19999 AND @counter

		SET @counter = @counter - 20000
	END

END
GO


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON REPLICATED SERVER --
-----------------------------------------------------------

-- Selected super lines for import data --
CREATE TABLE	#supers (
					custid INT,
					isfinished BIT DEFAULT(0)
				)

DECLARE @srecommend INT

INSERT INTO	#supers (custid)
SELECT	ci.custid
FROM	custInfo AS ci WITH(NOLOCK)
WHERE	username IN ('supertestuat6', 'staff')

-- Import virtual setting from old structure to new structure for selected super lines --
WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #supers
	SET		isfinished = 1,
			@srecommend = custid
	WHERE	isfinished = 0

	IF @@ROWCOUNT = 0
		BREAK

	EXECUTE Acc_CustSetting3rd_19 @srecommend = @srecommend, @target = 'REPLICATED'

	WAITFOR DELAY '00:00:00.280'
END
GO


-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Selected super lines for import data --
CREATE TABLE	#supers (
					custid INT,
					isfinished BIT DEFAULT(0)
				)

DECLARE @srecommend INT

INSERT INTO #supers (custid)
SELECT	ci.custid
FROM	custInfo AS ci WITH(NOLOCK)
WHERE	username IN ('supertestuat6', 'staff')

-- Import virtual setting from old structure to new structure for selected super lines --
WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #supers
	SET		isfinished = 1,
			@srecommend = custid
	WHERE	isfinished = 0

	IF @@ROWCOUNT = 0
		BREAK

	EXECUTE Acc_CustSetting3rd_19 @srecommend = @srecommend, @target = 'DBCUST'

	WAITFOR DELAY '00:00:00.280'
END
GO