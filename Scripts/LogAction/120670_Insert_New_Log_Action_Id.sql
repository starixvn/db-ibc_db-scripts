/*<info serverAlias="DBLOG-bodb_CustomerLog" isFunction="0" isNested=""></info>*/
/*	
	Created: 20200618@Sol
	Task: Add new row into logaction table - [Redmine:#120670]
	DB: DBLOG/bodb_CustomerLog
*/

USE bodb_CustomerLog

GO 

INSERT INTO LogAction
(
	ActionID, 
	ActionTypeID, 
	SPName, 
	ActionNameEN, 
	IsInternal, 
	ActionNameCH,
	ActionNameCS,
	ActionNameJP,
	ActionNameIT,
	ActionNameTH,
	ActionNameKO,
	ActionNameVI,
	ActionNameCN
)
VALUES 
(
	95026, 
	4, 
	'Acc_LicenseeTransferCode_Ins', 
	'Insert licensee code to Licensee', 
	1,
	'Insert licensee code to Licensee',
	'Insert licensee code to Licensee',
	'Insert licensee code to Licensee',
	'Insert licensee code to Licensee',
	'Insert licensee code to Licensee',
	'Insert licensee code to Licensee',
	'Insert licensee code to Licensee',
	'Insert licensee code to Licensee'
), 
(
	95027, 
	4, 
	'Acc_LicenseeTransferCode_Upd', 
	'Update licensee code to Licensee', 
	1,
	'Update licensee code to Licensee',
	'Update licensee code to Licensee',
	'Update licensee code to Licensee',
	'Update licensee code to Licensee',
	'Update licensee code to Licensee',
	'Update licensee code to Licensee',
	'Update licensee code to Licensee',
	'Update licensee code to Licensee'
)

GO