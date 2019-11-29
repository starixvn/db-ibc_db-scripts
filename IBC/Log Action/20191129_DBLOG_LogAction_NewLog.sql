USE bodb_CustomerLog
GO

/*
	Created: 20191129@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: Add log action for web
*/

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN)
SELECT 5513, 'LA_RebateIns', 'add new rebate ' UNION ALL
SELECT 5514, 'LA_RebateUpd', 'update rebate' UNION ALL
SELECT 5515, 'LA_RebateDel', 'delete rebate' UNION ALL
SELECT 5516, 'LA_DiscountIns', 'add new discount' UNION ALL
SELECT 5517, 'LA_DiscountUpd', 'update discount' UNION ALL
SELECT 5518, 'LA_DiscountDel', 'delete discount' UNION ALL
SELECT 5519, 'LA_DiscountUpd', 'Add/Remove discount product' UNION ALL
SELECT 5520, 'LA_DiscountUpd', 'Add/Remove discount party' UNION ALL
SELECT 5521, 'LA_DiscountUpd', 'Change discount rate settings' UNION ALL
SELECT 5522, 'Nap_LM_Operator_Insert', 'Insert Operator' UNION ALL
SELECT 5523, 'Nap_LM_Operator_Update', 'Update Operator' UNION ALL
SELECT 5524, 'Nap_LM_Operator_Import', 'Import Operator' UNION ALL
SELECT 5525, 'Nap_LM_Operator_Delete', 'Delete operator' UNION ALL
SELECT 5526, 'Nap_LM_Licensee_Insert', 'Set up new licensee' UNION ALL
SELECT 5527, 'Nap_LM_Licensee_AddAgent', 'Add new licensee agent/currency' UNION ALL
SELECT 5528, 'Nap_LM_Licensee_OfferProduct', 'Offer new product for licensee' UNION ALL
SELECT 5529, 'Nap_LM_Licensee_EnablePullService', 'Add licensee into pull service' UNION ALL
SELECT 5530, 'Nap_LM_Licensee_RemoveProduct', 'Remove product from licensee' UNION ALL
SELECT 5531, 'Nap_LM_Licensee_Terminate', 'Terminate Licensee' UNION ALL
SELECT 5532, 'Nap_LM_SourceLicensee_Insert', 'Add new Source Licensee Setting' UNION ALL
SELECT 5533, 'Nap_LM_SourceLicensee_Update', 'Update Source Licensee Setting' UNION ALL
SELECT 5534, 'LA_ModifySetting', 'insert/update new key/value' UNION ALL
SELECT 5535, 'LA_LaunchLicensee', 'Launch new licensee' UNION ALL
SELECT 5536, 'Nap_LM_LrfFunction_Insert', 'Add new LRF Function' UNION ALL
SELECT 5537, 'Nap_LM_LrfFunction_Update', 'Update LRF Function' UNION ALL
SELECT 5538, 'Nap_LM_Licensee_ActivateSystem', 'Activate System for Licensee' UNION ALL
SELECT 5539, 'Nap_LM_LrfFunction_AssignToLicensee', 'Assign LRF Function to Licensee' UNION ALL
SELECT 5540, 'Nap_LM_ITUser_Insert', 'Add new IT User' UNION ALL
SELECT 5541, 'Nap_LM_ITUser_AssignToLicensee', 'Assign IT User to Licensee' UNION ALL
SELECT 5542, 'Nap_LM_ITUser_UpdateFunction', 'Update LRF Function of IT User' UNION ALL
SELECT 5543, 'Nap_LM_ITUser_UpdateCurrency', 'Update Currency of IT User' UNION ALL
SELECT 5544, 'Nap_LM_ITUser_Update', 'Update IT User' UNION ALL
SELECT 5545, 'Nap_LM_ITUser_ResetPassword', 'Reset IT User Password' UNION ALL
SELECT 5546, 'LA_ChargeRateGroupChange', 'Update charge rate group' UNION ALL
SELECT 5547, 'LA_LicenseeGroupIns', 'Add new licensee group' UNION ALL
SELECT 5548, 'LA_LicenseeGroupUpd', 'Update licensee group' UNION ALL
SELECT 5549, 'LA_LicenseeGroupDel', 'Delete licensee group' UNION ALL
SELECT 5566, 'Nap_LM_LAPUser_Insert', 'Insert new LAP USER' UNION ALL
SELECT 5567, 'Nap_LM_LAPUser_UpdatePW', 'Update LAP USER INFO'
GO

UPDATE dbo.LogAction WITH (ROWLOCK)
SET IsInternal = 0
	,ActionNameCH = ActionNameEN
	,ActionNameCS = ActionNameEN
	,ActionNameJP = ActionNameEN
	,ActionNameIT = ActionNameEN
	,ActionNameTH = ActionNameEN
	,ActionNameKO = ActionNameEN
	,ActionNameVI = ActionNameEN
	,ActionNameCN = ActionNameEN
WHERE ActionID BETWEEN 5513 AND 5549 OR ActionID IN (5566, 5567)