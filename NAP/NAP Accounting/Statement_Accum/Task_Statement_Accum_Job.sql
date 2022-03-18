/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[Task_Statement_Accum_Job]
AS

/*
	Created: 20220421@Percy
	DB: DBRPT-bodb_Report
	Task: Statement_Accum - Generate data

	Revisions:
		- 20220421@Percy: Initialize SP [RedmineID: #102322]
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @CustId INT, @i INT, @n INT
	SELECT @i = MIN(Id), @n = MAX(Id) FROM dbo.Cust_Statement WITH (NOLOCK) WHERE IsFinished = 0

	WHILE @i <= @n
	BEGIN
		SET @CustId = NULL

		SELECT @CustId = CustId FROM dbo.Cust_Statement WITH (NOLOCK) WHERE Id = @i AND IsFinished = 0

		IF @CustId IS NOT NULL
		BEGIN
			EXEC dbo.Task_Statement_Accum @CustId = @CustId

			WAITFOR DELAY '00:00:00.003'
		END

		SET @i = @i + 1
	END
END
GO