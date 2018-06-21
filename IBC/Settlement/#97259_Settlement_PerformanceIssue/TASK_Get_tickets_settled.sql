
CREATE PROCEDURE [dbo].[TASK_Get_tickets_settled]
	@lastID bigint
	,@batchSize int = 100
	,@maxID bigint OUTPUT
	,@TransIDs varchar(MAX) OUTPUT
AS
/*
	20180621 @ Viet
	DB053.bodb02
*/
BEGIN
	SET @maxID = @lastID
	SET @TransIDs = ''
	SELECT @maxID = MAX(ID)
	FROM dbo.Tickets_settled WITH(NOLOCK)
	WHERE ID BETWEEN @lastID + 1 AND @lastID + @batchSize

	IF (@maxID = @lastID) RETURN -- no row
	

	SELECT @TransIDs = STUFF((
		SELECT ',' + cast(transid as varchar(2)) 
		FROM dbo.Tickets_settled WITH(NOLOCK)
		WHERE ID BETWEEN @lastID + 1 AND @maxID
		FOR XML PATH('')
	), 1,1,'')
END