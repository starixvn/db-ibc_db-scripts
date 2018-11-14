/*
	Created: 20181101@Percy
	DB: DB053
	Task: Remove unused tables
*/
use Bodb_LicenseeReport
go 
exec sp_rename 'tbl_Customer_Account', 'DEL_tbl_Customer_Account' 
go
use bodb_PlaytechCS
go 
exec sp_rename 'bettrans', 'DEL_bettrans' 
go
use bodb_PlaytechCS
go 
exec sp_rename 'LicenseeVersionKey', 'DEL_LicenseeVersionKey' 
go
use bodb_PlaytechCS
go 
exec sp_rename 'Product3rd_ImportQueue_bk', 'DEL_Product3rd_ImportQueue_bk' 
go