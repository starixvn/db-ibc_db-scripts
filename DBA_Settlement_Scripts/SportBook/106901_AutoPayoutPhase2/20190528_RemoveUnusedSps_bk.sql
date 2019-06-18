/*
	Created: 20190528@Sol
	DB: Archived Dbs
	Task: Remove unused stored procedure
*/

USE bodb_Archive;

go 
exec sp_rename 'NAP_Admin_Settlement_FGLG_Push', 'DEL_NAP_Admin_Settlement_FGLG_Push' 

go 
exec sp_rename 'NAP_Admin_Settlement_FGLG', 'DEL_NAP_Admin_Settlement_FGLG' 

go 
exec sp_rename 'NAP_Set_AutoPayout_MatchSelFGLG', 'DEL_NAP_Set_AutoPayout_MatchSelFGLG' 

go 
exec sp_rename 'NAP_Admin_Settlement_Refund_FGLG_Push', 'DEL_NAP_Admin_Settlement_Refund_FGLG_Push' 

go 
exec sp_rename 'NAP_Admin_Settlement_Refund_FGLG', 'DEL_NAP_Admin_Settlement_Refund_FGLG' 