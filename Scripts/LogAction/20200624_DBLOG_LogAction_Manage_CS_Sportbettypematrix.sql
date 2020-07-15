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
    (95023,4,'Acc_CS_SportBettypeMatrix_Ins',N'Insert into CS_SportBettypeMatrix table',1),	
	(95024,4,'Acc_CS_SportBettypeMatrix_Upd',N'Update CS_SportBettypeMatrix table',1),
	(95025,4,'Acc_CS_SportBettypeMatrix_Del',N'Delete a row of CS_SportBettypeMatrix table',1)
																	

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