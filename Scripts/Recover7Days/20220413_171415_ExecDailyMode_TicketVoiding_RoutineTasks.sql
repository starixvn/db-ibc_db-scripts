/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20220414@Sophia
	Task: re-gen data mode Daily TicketVoiding_RoutineTasks [Redmine: #171415] 
	DB: DBTXN-bodb02
*/ 
 
USE bodb02;

GO  
	DECLARE  @stepNo		TINYINT  , 
			 @AffectedList	VARCHAR(MAX) = NULL,
			 @ExecuteType	TINYINT,
			 @errmsg		VARCHAR(1000) = ''  ,
			 @winlostdate DATETIME 
	
	DECLARE @inputList TABLE (custid INT, winlostdate DATETIME, isDone BIT) 

	
	SELECT @stepNo = 5

	WHILE @stepNo <= 8
	BEGIN
		WITH rs
		AS (
			SELECT *
				,cast(affectedList AS XML) AS xmldata
			FROM TicketVoiding_RoutineTasks WITH(NOLOCK)
			WHERE stepno = @stepNo AND status = 0 and RequestID = 21
			)
		INSERT INTO @inputList(custid,winlostdate,isDone)
		SELECT t.c.value('@c', 'INT') AS CustId
			,t.c.value('@w', 'SMALLDATETIME') AS WinlostDate
			, 0 AS isDone 
		FROM rs
		CROSS APPLY xmldata.nodes('root/r') AS t(c)
	 



		IF @stepNo IN (5,6,7,8)   -- those kind of execution only need input @winlostdate 
		BEGIN
			WHILE EXISTS (SELECT 1 FROM @inputList WHERE isDone = 0)
			BEGIN
				SELECT TOP 1 @winlostdate = winlostdate
				FROM @inputList
				WHERE isDone = 0
				GROUP BY winlostdate 
				ORDER BY winlostdate
				
				SELECT @stepNo , @winlostdate 
				EXECUTE Task_Execute_TicketVoiding_RoutineTasks @stepNo = @stepNo, @winlostdate = @winlostdate, @errmsg = @errmsg OUTPUT
	

				UPDATE @inputList
				SET isDone = 1
				WHERE winlostdate = @winlostdate
			END
		END
	
		SELECT @stepNo = @stepNo + 1
	END


	-------------------- Update Status completed for TicketVoiding_RoutineTasks 

	UPDATE TicketVoiding_RoutineTasks WITH (ROWLOCK) 
	SET		Status = 2 
	WHERE  RequestID = 21 AND ExecuteType = 2  and Status = 0