use [bodb_licensee]
go

/*
	Created: 20190424@Percy
	DB: DB052.bodb_Licensee
	Task: Moved SPs - Step 1: Rename to DEL_
*/

sp_rename 'Aff_UserLogin', 'DEL_Aff_UserLogin'
go
sp_rename 'AffAdmin_CheckIn', 'DEL_AffAdmin_CheckIn'
go
sp_rename 'AffAdmin_ITAdminUser_Insert', 'DEL_AffAdmin_ITAdminUser_Insert'
go
sp_rename 'AffAdmin_ReCheckIn', 'DEL_AffAdmin_ReCheckIn'
go
sp_rename 'AffAdmin_UserInfoSelByUserName', 'DEL_AffAdmin_UserInfoSelByUserName'
go