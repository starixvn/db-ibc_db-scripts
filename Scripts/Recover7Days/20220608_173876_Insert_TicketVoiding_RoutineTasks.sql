/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20220608@Sol
	Task: re-gen data by insert into TicketVoiding_RoutineTasks table - [Redmine: #173876] 
	DB: DBTXN-bodb02
*/ 
 
USE bodb02;

GO 
---step 5
DECLARE  
	@custIDs		VARCHAR(MAX) = '52210028', 
	@winlostdate	DATETIME = '2022-06-01',
	@errmsg		VARCHAR(1000) = '' ,
	@stepNo		TINYINT = 5

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg

BEGIN
	-- update status of step 6 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '173876-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = @stepNo
		AND status = 0
		AND ID = 173
		AND RequestId = 22
	
END

GO 

---step 6
DECLARE  
	@custIDs		VARCHAR(MAX) = '52210028', 
	@winlostdate	DATETIME = '2022-06-01',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 6

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg

IF (@errmsg = '')
BEGIN
	-- update status of step 6 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '173876-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = @stepNo
		AND status = 0
		AND ID = 174
		AND RequestId = 22
END
GO 

---step 7
DECLARE  
	@custIDs		VARCHAR(MAX) = '52210028', 
	@winlostdate	DATETIME = '2022-06-01',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 7

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg

IF (@errmsg = '')
BEGIN
	-- update status of step 6 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '173876-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = @stepNo
		AND status = 0
		AND ID = 175
		AND RequestId = 22
END
GO 

---step 8
DECLARE  
	@custIDs		VARCHAR(MAX) = '52210028', 
	@winlostdate	DATETIME = '2022-06-01',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 8

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg

IF (@errmsg = '')
BEGIN
	-- update status of step 6 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '173876-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = @stepNo
		AND status = 0
		AND ID = 176
		AND RequestId = 22
END
GO 