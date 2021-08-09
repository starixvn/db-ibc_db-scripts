/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

USE bodb_RMS

SET QUOTED_IDENTIFIER ON
GO
ALTER TABLE [dbo].rmBettransm_bk ADD 
	
	[betteam] [nvarchar](10) NULL,
	[bettype] [smallint] NULL
	
	
GO

------------------------------------------------------------------
-- UPDATE DATA into rmBettransm_bk
BEGIN
	DECLARE @FromDate SMALLDATETIME, @ToDate SMALLDATETIME
	DECLARE @winlostdate SMALLDATETIME

	SELECT @ToDate = MAX(winlostdate), @FromDate = MIN(winlostdate) FROM dbo.rmBettransm_bk WITH(NOLOCK)
	SELECT @winlostdate = @FromDate

	CREATE TABLE #bettransm_staging (
			transid			BIGINT,
			refno			BIGINT, 
			winlostdate		SMALLDATETIME, 
			betteam			NVARCHAR(10),
			bettype			SMALLINT 
	)

	WHILE  @winlostdate <= @ToDate
	BEGIN
		BEGIN TRY
			TRUNCATE TABLE #bettransm_staging

			INSERT INTO #bettransm_staging (transid, refno, winlostdate, betteam, bettype)
			SELECT  transid, refno, winlostdate, betteam, bettype
			FROM 	DBARC.bodb_archive.dbo.bettransm r WITH (NOLOCK)
			WHERE   r.winlostdate = @winlostdate

			UPDATE  t
			SET		t.betteam = u.betteam,
					t.bettype = u.bettype
			FROM dbo.rmBettransm_bk t WITH(ROWLOCK, UPDLOCK)
			INNER JOIN #bettransm_staging u ON t.refno = u.refno AND t.transid = u.transid
			WHERE t.winlostdate = @winlostdate
		
			SELECT @winlostdate = DATEADD(DAY, 1, @winlostdate)
		END TRY
		BEGIN CATCH
			RETURN
		END CATCH
		
	END

	DROP TABLE #bettransm_staging

END


