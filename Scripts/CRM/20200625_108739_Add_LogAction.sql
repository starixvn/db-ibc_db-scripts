/*<info serverAlias="DBCRM-bodb_CRM"></info>*/

/*
	Created by: Malcolm
	Date: 20200625
	Task: Insert LogAction into table  [#RedmindId: 108739]
	DB: DBCRM-bodb_CRM
*/
INSERT INTO dbo.crmLogAction
(
	ActionID,	
	SPName,	
	ActionNameEN,
	IsInternal,
	ExcludedForCn88
)
VALUES (901,'Acc_CRM_PicIns','Insert new PIC',0,1),
	(902,'Acc_CRM_PicUpd','Update PIC',0,1),
	(903,'Acc_CRM_PicStatusUpd','PIC status',0,1),	
	(904,'Acc_CRM_PICAssignmentDel','Remove PIC assignment',0,1),
	(905,'Acc_CRM_PICAssignment','New assign PIC',0,1)

