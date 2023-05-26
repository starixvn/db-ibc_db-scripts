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
	-- Drop SP
	IF OBJECT_ID('dbo.DEL_Acc_ExchangeRate_InvalidTransfer_Del','P') IS NOT NULL  
		DROP PROCEDURE DEL_Acc_ExchangeRate_InvalidTransfer_Del;  
		
	IF OBJECT_ID('dbo.DEL_Acc_LicenseeTransfer_Pool_CheckStatus','P') IS NOT NULL  
		DROP PROCEDURE DEL_Acc_LicenseeTransfer_Pool_CheckStatus;

	IF OBJECT_ID('dbo.DEL_Acc_LicenseeTransferCode_Update','P') IS NOT NULL  
		DROP PROCEDURE DEL_Acc_LicenseeTransferCode_Update;

	IF OBJECT_ID('dbo.DEL_DBA_GetSPText','P') IS NOT NULL  
		DROP PROCEDURE DEL_DBA_GetSPText;

	IF OBJECT_ID('dbo.DEL_Dot_Dep_BettransInsCancelWithdrawal_Cust','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Dep_BettransInsCancelWithdrawal_Cust;

	IF OBJECT_ID('dbo.DEL_Dot_Dep_BettransInsTransaction_V2_Cust','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Dep_BettransInsTransaction_V2_Cust;

	IF OBJECT_ID('dbo.DEL_Dot_Int_BettransInsCancelTransfer_Cust','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Int_BettransInsCancelTransfer_Cust;

	IF OBJECT_ID('dbo.DEL_Dot_Int_BettransInsTransactionWithoutLog_Cust','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Int_BettransInsTransactionWithoutLog_Cust;

	IF OBJECT_ID('dbo.DEL_Acc_LicenseeTransfer_Job','P') IS NOT NULL  
		DROP PROCEDURE DEL_Acc_LicenseeTransfer_Job;

	IF OBJECT_ID('dbo.DEL_Acc_LicenseeTransfer_Pool_UpdateStatus','P') IS NOT NULL  
		DROP PROCEDURE DEL_Acc_LicenseeTransfer_Pool_UpdateStatus;

	IF OBJECT_ID('dbo.DEL_Acc_SelRefNo','P') IS NOT NULL  
		DROP PROCEDURE DEL_Acc_SelRefNo;

	IF OBJECT_ID('dbo.DEL_Acc_SelTransCode','P') IS NOT NULL  
		DROP PROCEDURE DEL_Acc_SelTransCode;

	IF OBJECT_ID('dbo.DEL_Acc_ShowNotificationWhenProcessingData','P') IS NOT NULL  
		DROP PROCEDURE DEL_Acc_ShowNotificationWhenProcessingData;

	IF OBJECT_ID('dbo.DEL_Age_MoveBetsProcessNotification','P') IS NOT NULL  
		DROP PROCEDURE DEL_Age_MoveBetsProcessNotification;

	IF OBJECT_ID('dbo.DEL_CS_f_BettypeGroupMatrix_Sel','P') IS NOT NULL  
		DROP PROCEDURE DEL_CS_f_BettypeGroupMatrix_Sel;

	IF OBJECT_ID('dbo.DEL_CS_f_BettypeMatrix_Sel','P') IS NOT NULL  
		DROP PROCEDURE DEL_CS_f_BettypeMatrix_Sel;

	IF OBJECT_ID('dbo.DEL_CS_f_SporttypeMatrix_Sel','P') IS NOT NULL  
		DROP PROCEDURE DEL_CS_f_SporttypeMatrix_Sel;

	IF OBJECT_ID('dbo.DEL_DBA_ClearBalanceWholeLine','P') IS NOT NULL  
		DROP PROCEDURE DEL_DBA_ClearBalanceWholeLine;

	IF OBJECT_ID('dbo.DEL_f_Get_MsgNamebyMsgID','FN') IS NOT NULL  
		DROP FUNCTION DEL_f_Get_MsgNamebyMsgID;

	IF OBJECT_ID('dbo.DEL_LAS_IssueNewTransCode','P') IS NOT NULL  
		DROP PROCEDURE DEL_LAS_IssueNewTransCode;

	IF OBJECT_ID('dbo.DEL_Lrf_f_Get_MsgNamebyMsgID','FN') IS NOT NULL  
		DROP FUNCTION DEL_Lrf_f_Get_MsgNamebyMsgID;

	IF OBJECT_ID('dbo.DEL_Lrf_f_TranslateMsg','FN') IS NOT NULL  
		DROP FUNCTION DEL_Lrf_f_TranslateMsg;

	IF OBJECT_ID('dbo.DEL_NAP_PayoutTrans_Upd','P') IS NOT NULL  
		DROP PROCEDURE DEL_NAP_PayoutTrans_Upd;

	IF OBJECT_ID('dbo.DEL_NAP_PayoutTrans_UpdateLockPassword','P') IS NOT NULL  
		DROP PROCEDURE DEL_NAP_PayoutTrans_UpdateLockPassword;

	IF OBJECT_ID('dbo.DEL_Task_Archive_SelectBetStatement','P') IS NOT NULL  
		DROP PROCEDURE DEL_Task_Archive_SelectBetStatement;

	IF OBJECT_ID('dbo.DEL_Task_Dep_AdjustData3rdProduct_tmp','P') IS NOT NULL  
		DROP PROCEDURE DEL_Task_Dep_AdjustData3rdProduct_tmp;

	IF OBJECT_ID('dbo.DEL_Aff_Admin_AffiliatePaymentRequest_Approve','P') IS NOT NULL  
		DROP PROCEDURE DEL_Aff_Admin_AffiliatePaymentRequest_Approve;

	IF OBJECT_ID('dbo.DEL_Aff_PaymentRequestApprove','P') IS NOT NULL  
		DROP PROCEDURE DEL_Aff_PaymentRequestApprove;

	IF OBJECT_ID('dbo.DEL_Age_Bonus_ConfirmPayment','P') IS NOT NULL  
		DROP PROCEDURE DEL_Age_Bonus_ConfirmPayment;

	IF OBJECT_ID('dbo.DEL_Age_Transfer_AllowIn24HoursCheck','P') IS NOT NULL  
		DROP PROCEDURE DEL_Age_Transfer_AllowIn24HoursCheck;

	IF OBJECT_ID('dbo.DEL_CS_Member_TotalBetStake_Sel','P') IS NOT NULL  
		DROP PROCEDURE DEL_CS_Member_TotalBetStake_Sel;

	IF OBJECT_ID('dbo.DEL_DBA_ClearBalanceWholeLine','P') IS NOT NULL  
		DROP PROCEDURE DEL_DBA_ClearBalanceWholeLine;
	----
	IF OBJECT_ID('dbo.DEL_Dot_Dep_BettransIns_PlayerTip','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Dep_BettransIns_PlayerTip;

	IF OBJECT_ID('dbo.DEL_Dot_Dep_BettransIns_PromotionPrize','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Dep_BettransIns_PromotionPrize;

	IF OBJECT_ID('dbo.DEL_Dot_Dep_BettransIns_SabaLoyaltyPE','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Dep_BettransIns_SabaLoyaltyPE;

	IF OBJECT_ID('dbo.DEL_Dot_Dep_BettransIns_SabaPromotion','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Dep_BettransIns_SabaPromotion;

	IF OBJECT_ID('dbo.DEL_Dot_Dep_BettransIns_SabaRedEnvelope','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Dep_BettransIns_SabaRedEnvelope;

	IF OBJECT_ID('dbo.DEL_Dot_Dep_BettransInsBonusWallet','P') IS NOT NULL  
		DROP PROCEDURE DEL_Dot_Dep_BettransInsBonusWallet;

	IF OBJECT_ID('dbo.DEL_NAP_PayoutTrans_Upd','P') IS NOT NULL  
		DROP PROCEDURE DEL_NAP_PayoutTrans_Upd;

	IF OBJECT_ID('dbo.DEL_Task_CS_HeadlineBalance_Add','P') IS NOT NULL  
		DROP PROCEDURE DEL_Task_CS_HeadlineBalance_Add;

	IF OBJECT_ID('dbo.DEL_Task_Daily3rdProductWinlost_Add','P') IS NOT NULL  
		DROP PROCEDURE DEL_Task_Daily3rdProductWinlost_Add;

	IF OBJECT_ID('dbo.DEL_Task_Dep_AdjustData3rdProduct_tmp','P') IS NOT NULL  
		DROP PROCEDURE DEL_Task_Dep_AdjustData3rdProduct_tmp;

	IF OBJECT_ID('dbo.DEL_Task_Dep_AdjustHistoricalData3rdProduct','P') IS NOT NULL  
		DROP PROCEDURE DEL_Task_Dep_AdjustHistoricalData3rdProduct;

	IF OBJECT_ID('dbo.DEL_Task_Dep_SumHistoryData3rdProduct','P') IS NOT NULL  
		DROP PROCEDURE DEL_Task_Dep_SumHistoryData3rdProduct;

	IF OBJECT_ID('dbo.DEL_Task_ResetWinning_3rdParty_Add','P') IS NOT NULL  
		DROP PROCEDURE DEL_Task_ResetWinning_3rdParty_Add;

	-- Drop table
	IF OBJECT_ID('dbo.DEL_Acc_ExchangeRate','U') IS NOT NULL  
		DROP TABLE DEL_Acc_ExchangeRate;

	IF OBJECT_ID('dbo.DEL_Acc_ExchangeRate_History','U') IS NOT NULL  
		DROP TABLE DEL_Acc_ExchangeRate_History;

	IF OBJECT_ID('dbo.DEL_Acc_ExchangeRate_InvalidTransfer','U') IS NOT NULL  
		DROP TABLE DEL_Acc_ExchangeRate_InvalidTransfer;

	IF OBJECT_ID('dbo.DEL_BonusTrans','U') IS NOT NULL  
		DROP TABLE DEL_BonusTrans;

	IF OBJECT_ID('dbo.DEL_PayoutTrans','U') IS NOT NULL  
		DROP TABLE DEL_PayoutTrans;

END

