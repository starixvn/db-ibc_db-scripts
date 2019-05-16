USE [bodb_CustomerLog]
GO

/*
	Created: 20190517@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: Insert new log action for web
*/

INSERT INTO dbo.LogAction (ActionID, SPName, ActionNameEN, IsInternal)
SELECT 5500, NULL, 'Import User', 0 UNION ALL
SELECT 5501, NULL, 'Import internal permission', 0 UNION ALL
SELECT 5502, NULL, 'Import currency permission', 0 UNION ALL
SELECT 5503, NULL, 'Import LRF permission', 0 UNION ALL
SELECT 5504, NULL, 'Import AFF permssion', 0 UNION ALL
SELECT 5505, NULL, 'Reset password', 0 UNION ALL
SELECT 5506, NULL, 'Update individual permission', 0 UNION ALL
SELECT 5507, NULL, 'Update user role', 0 UNION ALL
SELECT 5508, NULL, 'Update currency permission', 0 UNION ALL
SELECT 5509, NULL, 'Enable/Disable User', 0 UNION ALL
SELECT 5510, NULL, 'Add new user', 0 UNION ALL
SELECT 5511, NULL, 'Update group authority', 0 UNION ALL
SELECT 5512, NULL, 'Update LAP vendor info', 0 UNION ALL
SELECT 5513, 'LA_RebateIns', 'add new rebate ', 0 UNION ALL
SELECT 5514, 'LA_RebateUpd', 'update rebate', 0 UNION ALL
SELECT 5515, 'LA_RebateDel', 'delete rebate', 0 UNION ALL
SELECT 5516, 'LA_DiscountIns', 'add new discount', 0 UNION ALL
SELECT 5517, 'LA_DiscountUpd', 'update discount', 0 UNION ALL
SELECT 5518, 'LA_DiscountDel', 'delete discount', 0 UNION ALL
SELECT 5519, 'LA_DiscountUpd', 'Add/Remove discount product', 0 UNION ALL
SELECT 5520, 'LA_DiscountUpd', 'Add/Remove discount party', 0 UNION ALL
SELECT 5521, 'LA_DiscountUpd', 'Change discount rate settings', 0 UNION ALL
SELECT 5522, 'Nap_LM_Operator_Insert', 'Insert Operator', 0 UNION ALL
SELECT 5523, 'Nap_LM_Operator_Update', 'Update Operator', 0 UNION ALL
SELECT 5524, 'Nap_LM_Operator_Import', 'Import Operator', 0 UNION ALL
SELECT 5525, 'Nap_LM_Operator_Delete', 'Delete operator', 0 UNION ALL
SELECT 5526, 'Nap_LM_Licensee_Insert', 'Set up new licensee', 0 UNION ALL
SELECT 5527, 'Nap_LM_Licensee_AddAgent', 'Add new licensee agent/currency', 0 UNION ALL
SELECT 5528, 'Nap_LM_Licensee_OfferProduct', 'Offer new product for licensee', 0 UNION ALL
SELECT 5529, 'Nap_LM_Licensee_EnablePullService', 'Add licensee into pull service', 0 UNION ALL
SELECT 5530, 'Nap_LM_Licensee_RemoveProduct', 'Remove product from licensee', 0 UNION ALL
SELECT 5531, 'Nap_LM_Licensee_Terminate', 'Terminate Licensee', 0 UNION ALL
SELECT 5532, 'Nap_LM_SourceLicensee_Insert', 'Add new Source Licensee Setting', 0 UNION ALL
SELECT 5533, 'Nap_LM_SourceLicensee_Update', 'Update Source Licensee Setting', 0 UNION ALL
SELECT 5534, 'LA_ModifySetting', 'insert/update new key/value', 0 UNION ALL
SELECT 5535, 'LA_LaunchLicensee', 'Launch new licensee', 0 UNION ALL
SELECT 5536, 'Nap_LM_LrfFunction_Insert', 'Add new LRF Function', 0 UNION ALL
SELECT 5537, 'Nap_LM_LrfFunction_Update', 'Update LRF Function', 0 UNION ALL
SELECT 5538, 'Nap_LM_Licensee_ActivateSystem', 'Activate System for Licensee', 0 UNION ALL
SELECT 5539, 'Nap_LM_LrfFunction_AssignToLicensee', 'Assign LRF Function to Licensee', 0 UNION ALL
SELECT 5540, 'Nap_LM_ITUser_Insert', 'Add new IT User', 0 UNION ALL
SELECT 5541, 'Nap_LM_ITUser_AssignToLicensee', 'Assign IT User to Licensee', 0 UNION ALL
SELECT 5542, 'Nap_LM_ITUser_UpdateFunction', 'Update LRF Function of IT User', 0 UNION ALL
SELECT 5543, 'Nap_LM_ITUser_UpdateCurrency', 'Update Currency of IT User', 0 UNION ALL
SELECT 5544, 'Nap_LM_ITUser_Update', 'Update IT User', 0 UNION ALL
SELECT 5545, 'Nap_LM_ITUser_ResetPassword', 'Reset IT User Password', 0 UNION ALL
SELECT 5546, 'LA_ChargeRateGroupChange', 'Update charge rate group', 0 UNION ALL
SELECT 5547, 'LA_LicenseeGroupIns', 'Add new licensee group', 0 UNION ALL
SELECT 5548, 'LA_LicenseeGroupUpd', 'Update licensee group', 0 UNION ALL
SELECT 5549, 'LA_LicenseeGroupDel', 'Delete licensee group', 0

UPDATE dbo.LogAction WITH (ROWLOCK)
SET ActionNameCH = ActionNameEN,
	ActionNameCS = ActionNameEN,
	ActionNameJP = ActionNameEN,
	ActionNameIT = ActionNameEN,
	ActionNameTH = ActionNameEN,
	ActionNameKO = ActionNameEN,
	ActionNameVI = ActionNameEN,
	ActionNameCN = ActionNameEN
WHERE ActionID BETWEEN 5500 AND 5549