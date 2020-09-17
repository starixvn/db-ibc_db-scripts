/*<info serverAlias="DBLOG-bodb_CustomerLog"></info>*/

/*
	Created by: Danny
	Date: 20200917
	Task: Insert LogAction into table  [#redmindId: 131241]
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
	(95032,4,	'Acc_DWLList_Ins',N'Insert new Acc_DWLList',1),																			
	(95033,4,	'Acc_DWLList_Upd',N'Update Acc_DWLList',1),																			
	(95034,4,	'Acc_DWLList_ExtraPT_Ins',N'Insert new Acc_DWLList_ExtraPT',1),																			
	(95035,4,	'Acc_DWLList_ExtraPT_Upd',N'Update Acc_DWLList_ExtraPT',1)																																			

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
