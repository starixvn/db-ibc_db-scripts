USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[TASK_Get_tickets_settledByTimestamp]    Script Date: 6/21/2018 5:47:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TASK_Get_tickets_settledByTimestamp]
	@lastID binary(8)
	,@batchSize int = 100
	,@maxID binary(8) OUTPUT
	,@TransIDs varchar(8000) OUTPUT
AS
/*
	20180621 @ Viet
	DB053.bodb02
*/
BEGIN
	SET @maxID = @lastID	

	
	SET @TransIDs = ''
	
	declare @IDs as table (statusid tinyint, transid bigint, tstamp binary(8))
	INSERT INTO @IDs(statusid, transid, tstamp)
	SELECT TOP (@batchSize) statusid, transid, tstamp
	FROM dbo.bettrans with(nolock)
	where tstamp > @lastID
	ORDER BY tstamp ASC


	SELECT @maxID = MAX(tstamp) from @IDs
	SET @maxID = ISNULL(@maxID,@lastID)
	 
	/*
	WHILE (1=1)
	BEGIN
		SELECT @maxID = MAX(tstamp)
		FROM dbo.bettrans WITH(NOLOCK, INDEX=IX_ticketSettled)
		WHERE tstamp BETWEEN @lastID AND @temp_tstamp

		IF @@ROWCOUNT = 0
		SET @maxID = @temp_tstamp
		SET @temp_tstamp = cast((cast(@temp_tstamp as bigint) + @batchSize) as binary(8))
	END
	*/
	
	IF (@maxID = @lastID) RETURN -- no row
	

	SELECT @TransIDs = STUFF((
		SELECT ',' + cast(transid as varchar(15)) 
		FROM @IDs
		WHERE statusid > 1
		FOR XML PATH('')
	), 1,1,'')
END
