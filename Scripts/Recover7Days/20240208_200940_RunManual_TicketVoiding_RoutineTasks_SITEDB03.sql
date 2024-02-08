/*<info serverAlias="DBSIC-bodb02"></info>*/
/*
	Create: 20240208@Sophia
	Task: re-gen data by insert into TicketVoiding_RoutineTasks table - update status at sitedb03 only- [Redmine: #200940] 
	DB: SITEDB03-bodb02
*/ 
 
USE bodb02;

GO 
------------Update status step 5
BEGIN
	-- update status of step 6 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '200940-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 5	
		AND RequestId IN(347, 348)	
END

GO 
-----------------------------------------------------------------
--================================================================
 
------------update status step 6
IF (@errmsg = '')
BEGIN
	-- update status of step 6 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '200940-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 6
		AND status = 0 
		AND RequestId IN(347, 348)
END
GO 

-----------------------------------------------------------------
--================================================================

--------------------- update status step 7
IF (@errmsg = '')
BEGIN
	-- update status of step 7 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '200940-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 7
		AND status = 0		
		AND RequestId IN(347, 348)
END
GO 
-----------------------------------------------------------
--=============================================================
 
-------------------update status Step 8
IF (@errmsg = '')
BEGIN
	-- update status of step 8 in dbtxn
	UPDATE bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '200940-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 8
		AND status = 0
		AND RequestId IN(347, 348)
END
GO 