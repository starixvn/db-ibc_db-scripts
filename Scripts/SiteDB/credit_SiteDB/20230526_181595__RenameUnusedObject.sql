/*<info serverAlias="DBSIC-bodb02"></info>*/

/*
	Created by: Danny
	Date: 2023-05-26
	Task: Rename Unused Object
	DB: DBSIC-bodb02 
	
*/
USE bodb02
-- LOCAL, SIT, PROD
IF dbo.f_Get_SiteDBGroupID() = 3
BEGIN
	-- Rename SP
	IF OBJECT_ID('dbo.Acc_ExchangeRate_InvalidTransfer_Del','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_ExchangeRate_InvalidTransfer_Del', 'DEL_Acc_ExchangeRate_InvalidTransfer_Del';

	IF OBJECT_ID('dbo.Acc_LicenseeTransfer_Pool_CheckStatus','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_LicenseeTransfer_Pool_CheckStatus', 'DEL_Acc_LicenseeTransfer_Pool_CheckStatus';

	IF OBJECT_ID('dbo.Acc_LicenseeTransferCode_Update','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_LicenseeTransferCode_Update', 'DEL_Acc_LicenseeTransferCode_Update';

	IF OBJECT_ID('dbo.DBA_GetSPText','P') IS NOT NULL  
		EXEC sp_rename 'dbo.DBA_GetSPText', 'DEL_DBA_GetSPText';

	IF OBJECT_ID('dbo.Dot_Dep_BettransInsCancelWithdrawal_Cust','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Dep_BettransInsCancelWithdrawal_Cust', 'DEL_Dot_Dep_BettransInsCancelWithdrawal_Cust';

	IF OBJECT_ID('dbo.Dot_Dep_BettransInsTransaction_V2_Cust','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Dep_BettransInsTransaction_V2_Cust', 'DEL_Dot_Dep_BettransInsTransaction_V2_Cust';

	IF OBJECT_ID('dbo.Dot_Int_BettransInsCancelTransfer_Cust','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Int_BettransInsCancelTransfer_Cust', 'DEL_Dot_Int_BettransInsCancelTransfer_Cust';

	IF OBJECT_ID('dbo.Dot_Int_BettransInsTransactionWithoutLog_Cust','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Int_BettransInsTransactionWithoutLog_Cust', 'DEL_Dot_Int_BettransInsTransactionWithoutLog_Cust';

	IF OBJECT_ID('dbo.Acc_LicenseeTransfer_Job','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_LicenseeTransfer_Job', 'DEL_Acc_LicenseeTransfer_Job';

	IF OBJECT_ID('dbo.Acc_LicenseeTransfer_Pool_UpdateStatus','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_LicenseeTransfer_Pool_UpdateStatus', 'DEL_Acc_LicenseeTransfer_Pool_UpdateStatus';

	IF OBJECT_ID('dbo.Acc_SelRefNo','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_SelRefNo', 'DEL_Acc_SelRefNo';

	IF OBJECT_ID('dbo.Acc_SelTransCode','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_SelTransCode', 'DEL_Acc_SelTransCode';

	IF OBJECT_ID('dbo.Acc_ShowNotificationWhenProcessingData','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_ShowNotificationWhenProcessingData', 'DEL_Acc_ShowNotificationWhenProcessingData';

	IF OBJECT_ID('dbo.Age_MoveBetsProcessNotification','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Age_MoveBetsProcessNotification', 'DEL_Age_MoveBetsProcessNotification';

	IF OBJECT_ID('dbo.CS_f_BettypeGroupMatrix_Sel','P') IS NOT NULL  
		EXEC sp_rename 'dbo.CS_f_BettypeGroupMatrix_Sel', 'DEL_CS_f_BettypeGroupMatrix_Sel';

	IF OBJECT_ID('dbo.CS_f_BettypeMatrix_Sel','P') IS NOT NULL  
		EXEC sp_rename 'dbo.CS_f_BettypeMatrix_Sel', 'DEL_CS_f_BettypeMatrix_Sel';

	IF OBJECT_ID('dbo.CS_f_SporttypeMatrix_Sel','P') IS NOT NULL  
		EXEC sp_rename 'dbo.CS_f_SporttypeMatrix_Sel', 'DEL_CS_f_SporttypeMatrix_Sel';

	IF OBJECT_ID('dbo.DBA_ClearBalanceWholeLine','P') IS NOT NULL  
		EXEC sp_rename 'dbo.DBA_ClearBalanceWholeLine', 'DEL_DBA_ClearBalanceWholeLine';

	IF OBJECT_ID('dbo.f_Get_MsgNamebyMsgID','FN') IS NOT NULL  
		EXEC sp_rename 'dbo.f_Get_MsgNamebyMsgID', 'DEL_f_Get_MsgNamebyMsgID';

	IF OBJECT_ID('dbo.LAS_IssueNewTransCode','P') IS NOT NULL  
		EXEC sp_rename 'dbo.LAS_IssueNewTransCode', 'DEL_LAS_IssueNewTransCode';

	IF OBJECT_ID('dbo.Lrf_f_Get_MsgNamebyMsgID','FN') IS NOT NULL  
		EXEC sp_rename 'dbo.Lrf_f_Get_MsgNamebyMsgID', 'DEL_Lrf_f_Get_MsgNamebyMsgID';

	IF OBJECT_ID('dbo.Lrf_f_TranslateMsg','FN') IS NOT NULL  
		EXEC sp_rename 'dbo.Lrf_f_TranslateMsg', 'DEL_Lrf_f_TranslateMsg';

	IF OBJECT_ID('dbo.NAP_PayoutTrans_Upd','P') IS NOT NULL  
		EXEC sp_rename 'dbo.NAP_PayoutTrans_Upd', 'DEL_NAP_PayoutTrans_Upd';

	IF OBJECT_ID('dbo.NAP_PayoutTrans_UpdateLockPassword','P') IS NOT NULL  
		EXEC sp_rename 'dbo.NAP_PayoutTrans_UpdateLockPassword', 'DEL_NAP_PayoutTrans_UpdateLockPassword';

	IF OBJECT_ID('dbo.Task_Archive_SelectBetStatement','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Task_Archive_SelectBetStatement', 'DEL_Task_Archive_SelectBetStatement';

	IF OBJECT_ID('dbo.Task_Dep_AdjustData3rdProduct_tmp','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Task_Dep_AdjustData3rdProduct_tmp', 'DEL_Task_Dep_AdjustData3rdProduct_tmp';

	IF OBJECT_ID('dbo.Aff_Admin_AffiliatePaymentRequest_Approve','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Aff_Admin_AffiliatePaymentRequest_Approve', 'DEL_Aff_Admin_AffiliatePaymentRequest_Approve';

	IF OBJECT_ID('dbo.Aff_PaymentRequestApprove','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Aff_PaymentRequestApprove', 'DEL_Aff_PaymentRequestApprove';

	IF OBJECT_ID('dbo.Age_Bonus_ConfirmPayment','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Age_Bonus_ConfirmPayment', 'DEL_Age_Bonus_ConfirmPayment';

	IF OBJECT_ID('dbo.Age_Transfer_AllowIn24HoursCheck','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Age_Transfer_AllowIn24HoursCheck', 'DEL_Age_Transfer_AllowIn24HoursCheck';

	IF OBJECT_ID('dbo.CS_Member_TotalBetStake_Sel','P') IS NOT NULL  
		EXEC sp_rename 'dbo.CS_Member_TotalBetStake_Sel', 'DEL_CS_Member_TotalBetStake_Sel';

	IF OBJECT_ID('dbo.DBA_ClearBalanceWholeLine','P') IS NOT NULL  
		EXEC sp_rename 'dbo.DBA_ClearBalanceWholeLine', 'DEL_DBA_ClearBalanceWholeLinel';

	IF OBJECT_ID('dbo.DEL_Dot_Int_BettransInsTransaction_Cust','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Int_BettransInsTransaction_Cust;

	IF OBJECT_ID('dbo.Dot_Dep_BettransIns_PlayerTip','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Dep_BettransIns_PlayerTip', 'DEL_Dot_Dep_BettransIns_PlayerTip';

	IF OBJECT_ID('dbo.Dot_Dep_BettransIns_PromotionPrize','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Dep_BettransIns_PromotionPrize', 'DEL_Dot_Dep_BettransIns_PromotionPrize';

	IF OBJECT_ID('dbo.Dot_Dep_BettransIns_SabaLoyaltyPE','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Dep_BettransIns_SabaLoyaltyPE', 'DEL_Dot_Dep_BettransIns_SabaLoyaltyPE';

	IF OBJECT_ID('dbo.Dot_Dep_BettransIns_SabaPromotion','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Dep_BettransIns_SabaPromotion', 'DEL_Dot_Dep_BettransIns_SabaPromotion';

	IF OBJECT_ID('dbo.Dot_Dep_BettransIns_SabaRedEnvelope','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Dep_BettransIns_SabaRedEnvelope', 'DEL_Dot_Dep_BettransIns_SabaRedEnvelope';

	IF OBJECT_ID('dbo.Dot_Dep_BettransInsBonusWallet','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Dot_Dep_BettransInsBonusWallet', 'DEL_Dot_Dep_BettransInsBonusWallet';

	IF OBJECT_ID('dbo.NAP_PayoutTrans_Upd','P') IS NOT NULL  
		EXEC sp_rename 'dbo.NAP_PayoutTrans_Upd', 'DEL_NAP_PayoutTrans_Upd';

	IF OBJECT_ID('dbo.Task_CS_HeadlineBalance_Add','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Task_CS_HeadlineBalance_Add', 'DEL_Task_CS_HeadlineBalance_Add';

	IF OBJECT_ID('dbo.Task_Daily3rdProductWinlost_Add','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Task_Daily3rdProductWinlost_Add', 'DEL_Task_Daily3rdProductWinlost_Add';

	IF OBJECT_ID('dbo.Task_Dep_AdjustData3rdProduct_tmp','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Task_Dep_AdjustData3rdProduct_tmp', 'DEL_Task_Dep_AdjustData3rdProduct_tmp';

	IF OBJECT_ID('dbo.Task_Dep_AdjustHistoricalData3rdProduct','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Task_Dep_AdjustHistoricalData3rdProduct', 'DEL_Task_Dep_AdjustHistoricalData3rdProduct';

	IF OBJECT_ID('dbo.Task_Dep_SumHistoryData3rdProduct','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Task_Dep_SumHistoryData3rdProduct', 'DEL_Task_Dep_SumHistoryData3rdProduct';

	IF OBJECT_ID('dbo.Task_ResetWinning_3rdParty_Add','P') IS NOT NULL  
		EXEC sp_rename 'dbo.Task_ResetWinning_3rdParty_Add', 'DEL_Task_ResetWinning_3rdParty_Add';


	-- Rename table
	IF OBJECT_ID('dbo.Acc_ExchangeRate','U') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_ExchangeRate','DEL_Acc_ExchangeRate';

	IF OBJECT_ID('dbo.Acc_ExchangeRate_History','U') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_ExchangeRate_History','DEL_Acc_ExchangeRate_History';

	IF OBJECT_ID('dbo.Acc_ExchangeRate_InvalidTransfer','U') IS NOT NULL  
		EXEC sp_rename 'dbo.Acc_ExchangeRate_InvalidTransfer','DEL_Acc_ExchangeRate_InvalidTransfer';

	IF OBJECT_ID('dbo.BonusTrans','U') IS NOT NULL  
		EXEC sp_rename 'dbo.BonusTrans','DEL_BonusTrans';

	IF OBJECT_ID('dbo.PayoutTrans','U') IS NOT NULL  
		EXEC sp_rename 'dbo.PayoutTrans','DEL_PayoutTrans';

END