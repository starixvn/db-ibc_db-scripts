USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[TASK_Get_tickets_settledByTimestamp]    Script Date: 6/21/2018 4:34:59 AM ******/
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
	 	
	
	IF (@maxID = @lastID) RETURN -- no row
	

	SELECT @TransIDs = STUFF((
		SELECT ',' + cast(transid as varchar(15)) 
		FROM @IDs
		WHERE statusid > 1
		FOR XML PATH('')
	), 1,1,'')
END
