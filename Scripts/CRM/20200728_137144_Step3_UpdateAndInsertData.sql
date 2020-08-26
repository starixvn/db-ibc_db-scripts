/*<info serverAlias="DBCRM-bodb_CRM"></info>*/

USE bodb_CRM
GO

/*
	Created: 20200717@Malcolm
	DB: DBCRM.bodb_CRM
	Task:  update/insert date
	Revisions:
		- 20200717@Malcolm:  update/insert data [RedmineID: #137144]
*/
-- insert Log Action Type 
INSERT INTO dbo.crmLogActionType(ActionTypeID,ActionTypeName)
VALUES(1, 'PIC Management'),
	  (2,'PIC Assignment'),
	  (3,'Credit Term/Seach and Copy Super')

-- Insert LogAction
INSERT INTO dbo.crmLogAction
(
	ActionID,	
	SPName,	
	ActionNameEN,
	IsInternal,
	ExcludedForCn88,
	ActionTypeID
)
VALUES (906,'Acc_CRM_HeadlineUpd','Update the PIC of a headline',0,1,2),
	(907,'Acc_CRM_PicDefaultIns','Update Default PIC for a group headline',0,1,2),
	(908,'Acc_CRM_PicDefaultDel','Remove Default PIC for a group headline',0,1,2),
	(909,'Acc_CreditTermUpdAddToGroup','Add customer to Credit Term Group',1,1,3),
	(910,'Acc_CreditTermUpdCustomer','Update Credit Term',1,1,3),
	(911,'Acc_CreditTermUpdRemoveFromGroup','Remove customer from Credit Term Group',1,1,3),
	(912,'Acc_CreditTermUpdSetGroupHeadline','Set customer to Credit Term Headline',1,1,3),
	(913,'EAS_CustomerInsMember_CloneSetting_Com','Add the general information for super from existing super',1,1,3)

--Update ActionTypeID and ActionNameEN
UPDATE dbo.crmLogAction WITH(ROWLOCK)
SET ActionTypeID = 1
WHERE ActionID IN (901, 902, 903)

UPDATE dbo.crmLogAction WITH(ROWLOCK)
SET ActionNameEN = 'Update PIC status', ActionTypeID = 2
WHERE ActionID = 903

UPDATE dbo.crmLogAction WITH(ROWLOCK)
SET ActionNameEN = 'Remove direct account from PIC', ActionTypeID = 2
WHERE ActionID = 904

UPDATE dbo.crmLogAction WITH(ROWLOCK)
SET ActionNameEN = 'Assign direct account to PIC', ActionTypeID = 2
WHERE ActionID = 905

--Update data of the HeadlineID column
UPDATE m
SET m.HeadlineID = ISNULL(h.CustID,0)
FROM dbo.crmPicManagement m WITH(ROWLOCK)	
	LEFT JOIN bodb02.dbo.CustAccount ac WITH(NOLOCK) ON m.CustID = ac.custid
	LEFT JOIN bodb02.dbo.CustGroupHeadline h WITH(NOLOCK) ON ac.groupID = h.groupid
	

