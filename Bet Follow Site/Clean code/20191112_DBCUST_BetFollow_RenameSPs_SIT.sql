use CustDB
go

/*
	Created: 20191112@Percy
	DB: DBCUST.CustDB
	Task: Bet Follow - Rename SPs (SIT)
*/

sp_rename 'Acc_AutoFollowBetCustomerChecking', 'DEL_Acc_AutoFollowBetCustomerChecking'
go
sp_rename 'Acc_AutoFollowBetCustomerChecking_xtest', 'DEL_Acc_AutoFollowBetCustomerChecking_xtest'
go
sp_rename 'Acc_AutoFollowBetDelCustomer', 'DEL_Acc_AutoFollowBetDelCustomer'
go
sp_rename 'Acc_AutoFollowBetDelCustomer_xpre', 'DEL_Acc_AutoFollowBetDelCustomer_xpre'
go
sp_rename 'Acc_AutoFollowBetDelCustomer_xtest', 'DEL_Acc_AutoFollowBetDelCustomer_xtest'
go
sp_rename 'Acc_AutoFollowBetDelMultipleCustomer', 'DEL_Acc_AutoFollowBetDelMultipleCustomer'
go
sp_rename 'Acc_AutoFollowBetDelMultipleCustomer_xtest', 'DEL_Acc_AutoFollowBetDelMultipleCustomer_xtest'
go
sp_rename 'Acc_AutoFollowBetInsBACustomer', 'DEL_Acc_AutoFollowBetInsBACustomer'
go
sp_rename 'Acc_AutoFollowBetInsBACustomer_xpre', 'DEL_Acc_AutoFollowBetInsBACustomer_xpre'
go
sp_rename 'Acc_AutoFollowBetInsBACustomer_xtest', 'DEL_Acc_AutoFollowBetInsBACustomer_xtest'
go
sp_rename 'Acc_AutoFollowBetInsCustomer', 'DEL_Acc_AutoFollowBetInsCustomer'
go
sp_rename 'Acc_AutoFollowBetInsCustomer_xtest', 'DEL_Acc_AutoFollowBetInsCustomer_xtest'
go
sp_rename 'Acc_AutoFollowBetInsMultipleCustomer', 'DEL_Acc_AutoFollowBetInsMultipleCustomer'
go
sp_rename 'Acc_AutoFollowBetInsMultipleCustomer_xpre', 'DEL_Acc_AutoFollowBetInsMultipleCustomer_xpre'
go
sp_rename 'Acc_AutoFollowBetInsMultipleCustomer_xtest', 'DEL_Acc_AutoFollowBetInsMultipleCustomer_xtest'
go
sp_rename 'Acc_AutoFollowBetSelBACustomer', 'DEL_Acc_AutoFollowBetSelBACustomer'
go
sp_rename 'Acc_AutoFollowBetSelBACustomer_UAT4', 'DEL_Acc_AutoFollowBetSelBACustomer_UAT4'
go
sp_rename 'Acc_AutoFollowBetSelBACustomer_xpre', 'DEL_Acc_AutoFollowBetSelBACustomer_xpre'
go
sp_rename 'Acc_AutoFollowBetSelBACustomer_xtest', 'DEL_Acc_AutoFollowBetSelBACustomer_xtest'
go
sp_rename 'Acc_AutoFollowBetSelCustomer', 'DEL_Acc_AutoFollowBetSelCustomer'
go
sp_rename 'Acc_AutoFollowBetSelCustomer_xpre', 'DEL_Acc_AutoFollowBetSelCustomer_xpre'
go
sp_rename 'Acc_AutoFollowBetSelCustomer_xtest', 'DEL_Acc_AutoFollowBetSelCustomer_xtest'
go
sp_rename 'Acc_AutoFollowBetUpdRate', 'DEL_Acc_AutoFollowBetUpdRate'
go
sp_rename 'Acc_AutoFollowBetUpdRate_xpre', 'DEL_Acc_AutoFollowBetUpdRate_xpre'
go
sp_rename 'Acc_AutoFollowBetUpdRate_xtest', 'DEL_Acc_AutoFollowBetUpdRate_xtest'
go
