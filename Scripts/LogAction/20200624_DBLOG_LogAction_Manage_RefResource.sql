/*<info serverAlias="DBLOG-bodb_CustomerLog"></info>*/

/*
	Created by: Malcolm
	Date: 20200624
	Task: Add new row into logaction table  [#redmindId: 131241]
	DB: DBLOG/bodb_CustomerLog
*/
CREATE TABLE #TmpAction
(
	ActionID		INT,
	ActionTypeID	INT,
	SPName			VARCHAR(50),
	ActionNameEN	NVARCHAR(256),
	IsInternal		TINYINT
)
INSERT INTO #TmpAction (ActionID,ActionTypeID,SPName,ActionNameEN,IsInternal)
VALUES
    (95028,4,'Acc_RefResource_Ins',N'Insert data into RefResource table',1),	
	(95029,4,'Acc_RefResource_Upd',N'Update RefResource table',1),
	(95030,4,'Acc_RefResource_Del',N'Delete a row of RefResource table',1)
																	

INSERT INTO dbo.LogAction
(
	ActionID,	
	ActionTypeID,
	SPName,	
	ActionNameEN,
	IsInternal
)
SELECT 
	t.ActionID,	
	t.ActionTypeID,
	t.SPName,	
	t.ActionNameEN,
	t.IsInternal	
FROM #TmpAction t


DROP TABLE #TmpAction