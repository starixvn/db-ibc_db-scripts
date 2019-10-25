/*
	Created: 20191025@Percy
	DB: DB05x, DB06x
	Task: LicenseeBATransaction - Rename table
*/

--- bodb_Licensee
use bodb_Licensee
go

sp_rename 'LicenseeBATransaction', 'DEL_LicenseeBATransaction'
go