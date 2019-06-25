USE master
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.bodb_CustomerLog
	Task: Create new filegroup on bodb_CustomerLog
	Remark: Please change filename
*/

-- OWA_DATA
ALTER DATABASE bodb_Licensee
	ADD FILEGROUP OWA_DATA
GO

ALTER DATABASE bodb_Licensee
	ADD FILE
	(
		NAME = OWN_DATA,  
		FILENAME = 'OWN_DATA.ndf',  
		SIZE = 10MB,  
		MAXSIZE = 100MB,  
		FILEGROWTH = 5% 
	)
	TO FILEGROUP OWN_DATA
GO