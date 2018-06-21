USE [bodb02]
GO
CREATE PROCEDURE [dbo].[Task_SettleTicketsByTrans]	
AS
/*
	20180621 @ Viet
	DB042.bodb02
*/
BEGIN
	SET NOCOUNT ON;
	DECLARE @lastID bigint, @maxID bigint, @TransIDs varchar(MAX)
	SELECT @lastID = sValue FROM dbo.Tickets_settled_setting WITH(NOLOCK) WHERE sKey = 'bettrans'
	
	EXEC DB053.bodb02.dbo.TASK_Get_tickets_settled  @lastID = @lastID
		,@batchSize = 100
		,@maxID = @maxID OUTPUT
		,@TransIDs = @TransIDs OUTPUT
	
	IF @lastID = @maxID RETURN --no new row

	DECLARE @xml XML = N'<root><r>' + REPLACE(@TransIDs, ',', '</r><r>') + '</r></root>'	

	UPDATE dbo.bettrans WITH(ROWLOCK, UPDLOCK)
	SET  ruben =1, statusID = 88 -- no_more_running ticket
	WHERE transid IN (
		SELECT r.value('.','bigint')
		FROM @xml.nodes('//root/r') AS RECORDS(r)
	)

	UPDATE dbo.Tickets_settled_setting WITH(ROWLOCK, UPDLOCK) SET sValue = @maxID WHERE sKey = 'bettrans'
END
