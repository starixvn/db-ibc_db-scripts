USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[Task_SettleTicketsByTrans]    Script Date: 6/21/2018 5:46:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Task_SettleTicketsByTrans]	
AS
/*
	20180621 @ Viet
	DB042.bodb02
*/
BEGIN
	--SET NOCOUNT ON;
	DECLARE @lastID binary(8), @maxID binary(8), @TransIDs varchar(8000)
	SELECT @lastID = cast(sValue as binary(8)) 
	FROM dbo.Tickets_settled_setting WITH(NOLOCK) 
	WHERE sKey = 'bettrans_tstamp'
	
	EXEC DBAGE.bodb02.dbo.TASK_Get_tickets_settledByTimestamp  @lastID = @lastID
		,@batchSize = 200
		,@maxID = @maxID OUTPUT
		,@TransIDs = @TransIDs OUTPUT
	--SELECT @lastID, @maxID, @TransIDs
	IF @lastID = @maxID RETURN --no new row

	DECLARE @xml XML = N'<root><r>' + REPLACE(@TransIDs, ',', '</r><r>') + '</r></root>'	

	DECLARE @__TransIds TABLE (transid bigint primary key)
	INSERT @__TransIds(transid)
	SELECT r.value('.','bigint')
	FROM @xml.nodes('//root/r') AS RECORDS(r)
	OPTION (OPTIMIZE FOR (@xml = NULL ))
	
	UPDATE dbo.bettrans WITH(ROWLOCK, UPDLOCK)
	SET ruben = 1, statusID = 88 -- no_more_running ticket
	WHERE transid IN (
		SELECT transid
		FROM @__TransIds
	)

	UPDATE dbo.Tickets_settled_setting WITH(ROWLOCK, UPDLOCK) 
	SET sValue = cast(@maxID as bigint) 
	WHERE sKey = 'bettrans_tstamp'
END
