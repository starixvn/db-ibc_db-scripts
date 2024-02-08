/*<info serverAlias="DBCTG-bodb02"></info>*/
/*
	Create: 20240208@Sophia
	Task: re-gen data by insert into TicketVoiding_RoutineTasks table - [Redmine: #200940] 
	DB: DBTRANS-bodb02
*/ 
 
USE bodb02;

GO 
---step 5- '2024-01-29'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898,', 
	@winlostdate	DATETIME = '2024-01-29',
	@errmsg		VARCHAR(1000) = '' ,
	@stepNo		TINYINT = 5

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO

---step 5 - '2024-01-30'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-30',
	@errmsg		VARCHAR(1000) = '' ,
	@stepNo		TINYINT = 5

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 5 - '2024-01-31'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-31',
	@errmsg		VARCHAR(1000) = '' ,
	@stepNo		TINYINT = 5

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO

---step 5 - '2024-02-01'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-02-01',
	@errmsg		VARCHAR(1000) = '' ,
	@stepNo		TINYINT = 5

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO

---step 5 - '2024-02-02'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-02-02',
	@errmsg		VARCHAR(1000) = '' ,
	@stepNo		TINYINT = 5

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO

------------Update status step 5
BEGIN
	-- update status of step 6 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '200940-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 5	
		AND RequestId IN(367,368)
	
END

GO 
-----------------------------------------------------------------
--================================================================

---step 6 -'2024-01-29'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-29',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 6

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 6 -'2024-01-30'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-30',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 6

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 6 -'2024-01-31'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-31',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 6

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 6 -'2024-02-01'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-02-01',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 6

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 6 -'2024-02-02'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-02-02',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 6

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO
------------update status step 6
IF (@errmsg = '')
BEGIN
	-- update status of step 6 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '200940-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 6
		AND status = 0 
		AND RequestId IN(367,368)
END
GO 

-----------------------------------------------------------------
--================================================================

---step 7 -'2024-01-29'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-29',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 7

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 7 -'2024-01-30'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-30',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 7

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO



---step 7 -'2024-01-31'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-31',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 7

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 7 -'2024-02-01'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-02-01',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 7

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO

---step 7 -'2024-02-02'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-02-02',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 7

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO

--------------------- update status step 7
IF (@errmsg = '')
BEGIN
	-- update status of step 7 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '200940-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 7
		AND status = 0		
		AND RequestId IN(367,368)
END
GO 
-----------------------------------------------------------
--=============================================================

---step 8 -'2024-01-29'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-29',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 8

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 8 -'2024-01-30'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-30',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 8

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 8 -'2024-01-31'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-01-31',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 8

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO

---step 8 -'2024-02-01'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-02-01',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 8

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO


---step 8 -'2024-02-02'
DECLARE  
	@custIDs		VARCHAR(MAX) = '109833810,109833839,109833878,109833898', 
	@winlostdate	DATETIME = '2024-02-02',
	@errmsg		VARCHAR(1000) = ''  ,
	@stepNo		TINYINT = 8

EXEC [dbo].[Task_Execute_TicketVoiding_RoutineTasks]
	 @stepNo	= @stepNo	,
	 @custIDs		 = @custIDs, 
	 @winlostdate	= @winlostdate,
	 @errmsg		= @errmsg OUTPUT

SELECT @errmsg
GO

-------------------update status Step 8
IF (@errmsg = '')
BEGIN
	-- update status of step 8 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '200940-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 8
		AND status = 0
		AND RequestId IN(367,368)
END
GO 