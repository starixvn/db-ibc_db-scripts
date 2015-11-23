/*
	Created: 20151111@Billy
	Task: Initial data on UAT environment (Non-UM Time)
	DB: DBCUST.CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Insert data to [ProfileVirtualSetting] table --
INSERT INTO [dbo].[ProfileVirtualSetting] (sporttype, bettype, islive, isActive)
SELECT sporttype, bettype, islive, isActive
FROM (
    SELECT TOP 120 sporttype, bettype, islive
    FROM (
        SELECT sporttype, bettype		
        FROM (
            SELECT 1    AS sporttype				-- Soccer
            UNION ALL
            SELECT 2    AS sporttype				-- Basketball
            UNION ALL
            SELECT 3    AS sporttype				-- Football
            UNION ALL
            SELECT 99   AS sporttype				-- Other sports
        ) st
        CROSS APPLY (
            SELECT 1    AS bettype					-- Handicap
            UNION ALL
            SELECT 2    AS bettype					-- Odd/Even
            UNION ALL
            SELECT 3    AS bettype					-- Over/Under
            UNION ALL
            SELECT 7    AS bettype					-- 1H Handicap
            UNION ALL
            SELECT 8    AS bettype					-- 1H Over/Under
            UNION ALL
            SELECT 12   AS bettype					-- 1H Odd/Even
        ) bt
        
        UNION ALL
        SELECT sporttype, bettype		
        FROM (
            SELECT 4    AS sporttype				-- Ice Hockey
            UNION ALL
            SELECT 5    AS sporttype				-- Tennis
            UNION ALL
            SELECT 6    AS sporttype				-- Volleyball
            UNION ALL
            SELECT 7    AS sporttype				-- Snooker/Pool
            UNION ALL
            SELECT 9    AS sporttype				-- Badminton
            UNION ALL
            SELECT 11   AS sporttype				-- Motorsports
            UNION ALL
            SELECT 27   AS sporttype				-- Cricket
        ) st
        CROSS APPLY (
            SELECT 1    AS bettype					-- Handicap
            UNION ALL
            SELECT 2    AS bettype					-- Odd/Even
            UNION ALL
            SELECT 3    AS bettype					-- Over/Under
            UNION ALL
            SELECT 20   AS bettype					-- Moneyline
        ) bt

        UNION ALL
        SELECT sporttype, bettype		
        FROM (
            SELECT 8    AS sporttype				-- Baseball
        ) st
        CROSS APPLY (
            SELECT 1    AS bettype					-- Handicap
            UNION ALL
            SELECT 3    AS bettype					-- Over/Under
            UNION ALL
            SELECT 7    AS bettype					-- 1H Handicap
            UNION ALL
            SELECT 8    AS bettype					-- 1H Over/Under
            UNION ALL
            SELECT 20   AS bettype					-- Moneyline
            UNION ALL
            SELECT 21   AS bettype					-- 1st Moneyline
        ) bt

        UNION ALL
        SELECT 5  AS sporttype, 1324 AS bettype		-- Tennis - Set x Game y Winner
        UNION ALL									
        SELECT 99 AS sporttype, 20   AS bettype		-- Other Sports - Moneyline
    ) sbt
    CROSS APPLY (
        SELECT 0 AS islive
        UNION ALL
        SELECT 1 AS islive
    ) il
    ORDER BY sporttype, bettype, islive
) ref
CROSS APPLY (
	SELECT 1 AS isActive
) ia
GO


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON REPLICATED SERVER --
-----------------------------------------------------------

-- Create function needed to import data from old table [CustVirtualRate] to new table [CustVirtualSetting] --
CREATE FUNCTION [dbo].[f_TransferVirtualSetting] (@bitmap binary(64), @custid int, @seqNo tinyint)  
	RETURNS binary(64) AS  
 /*  
	  Created:  
	  DB: DBCust.custDB  
  
	  Revision:      
	  Param's Explanation:  
 */  
BEGIN 	

	SELECT 	@bitmap = dbo.f_GenerateVirtualSetting(@bitmap, pvs.profileID, COALESCE(cvr.virtualMultiplier, 1.00))
	FROM 		ProfileVirtualSetting AS pvs WITH(NOLOCK)
	LEFT JOIN 	CustVirtualRate AS cvr WITH(NOLOCK)
			ON 	((pvs.sporttype = cvr.sporttype) OR (pvs.sporttype <> 1 AND cvr.sporttype = 99))
			AND pvs.bettype = cvr.bettype
			AND pvs.islive = cvr.isLive
			AND cvr.custid = @custid
	WHERE 	pvs.seqNo = @seqNo

	RETURN @bitmap
END
GO


-- BEGIN STEP 4: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
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

	SELECT @counter = (SELECT COUNT(1) FROM custInfo WHERE srecommend = @srecommend)

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


-- BEGIN STEP 5: DEPLOY THIS SCRIPT ON REPLICATED SERVER --
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
WHERE	username IN ('supertestuat6')

-- Import virtual setting from old structure to new structure for selected super lines --
WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #supers
	SET		isfinished = 1,
			@srecommend = custid
	WHERE	isfinished = 0

	IF @@ROWCOUNT = 0
		BREAK

	EXECUTE Acc_CustSetting3rd_19 @srecommend, 'REPLICATED'

	WAITFOR DELAY '00:00:00.280'
END
GO


-- BEGIN STEP 6: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
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
WHERE	username IN ('supertestuat6')

-- Import virtual setting from old structure to new structure for selected super lines --
WHILE (0 = 0)
BEGIN
	UPDATE TOP(1) #supers
	SET		isfinished = 1,
			@srecommend = custid
	WHERE	isfinished = 0

	IF @@ROWCOUNT = 0
		BREAK

	EXECUTE Acc_CustSetting3rd_19 @srecommend, 'DBCUST'

	WAITFOR DELAY '00:00:00.280'
END
GO