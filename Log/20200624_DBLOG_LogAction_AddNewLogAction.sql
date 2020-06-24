/*<info serverAlias="DBLOG-bodb_CustomerLog"></info>*/

/*
	Created by: Malcolm
	Date: 20200624
	Task: Insert LogAction into table  [#redmindId: 35057]
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
    (662,4,'Acc_CustGroupUpdPrimaryExtraPTGroup',N'Change Primary Extra PT Group',1),
	(95002,4,	'CS_ReportPermission_Upd',N'Update view all periods',1),																			
	(95003,4,	'Acc_FinancePermissionIns',N'Insert Admin / finance code',1),																			
	(95004,4,	'Acc_FinancePermissionDel',N'Delete Admin / finance code',1),
	(95005,4,	'Acc_Bettype_Ins',N'Insert new bettypes',1),																			
	(95006,4,	'Acc_Bettype_Upd',N'Update bettypes',1),																			
	(95007,4,	'Acc_Sporttype_Ins',N'Insert new Sports',1),																			
	(95008,4,	'Acc_Sporttype_Upd',N'Update Sports',1),																				
	(95011,4,	'Acc_Product_Ins',N'Insert new products',1),																			
	(95012,4,	'Acc_Product_Upd',N'Update products',1),																			
	(95013,4,	'Acc_SportBettypeMatrix_Ins',N'Insert into SportBettypeMatrix table',1),																			
	(95014,4,	'Acc_SportBettypeMatrix_Upd',N'Update SportBettypeMatrix table',1),																			
	(95015,4,	'Acc_SportBettypeMatrix_Del',N'delete a row of SportBettypeMatrix table',1)																			

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
WHERE NOT EXISTS(
	SELECT 1 FROM dbo.LogAction WHERE ActionID = t.ActionID)

DROP TABLE #TmpAction