USE master
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.bodb_Licensee, DB053.bodb_Licensee, DB06.bodb_Licensee
	Task: Create new filegroups on bodb_Licensee
*/

-- OWA_DATA
ALTER DATABASE bodb_Licensee
	ADD FILEGROUP OWA_DATA
GO

ALTER DATABASE bodb_Licensee
	ADD FILE
	(
		NAME = OWA_DATA,  
		FILENAME = 'H:\USER_DB\bodb_licensee\OWN_DATA.ndf',  
		SIZE = 16MB,  		
		FILEGROWTH = 16MB 
	)
	TO FILEGROUP OWA_DATA
GO

-- OWA_INDEX
ALTER DATABASE bodb_Licensee
	ADD FILEGROUP OWA_INDEX
GO

ALTER DATABASE bodb_Licensee
	ADD FILE
	(
		NAME = OWA_INDEX,  
		FILENAME = 'H:\USER_DB\bodb_licensee\OWA_INDEX.ndf',  
		SIZE = 16MB,   
		FILEGROWTH = 16MB 
	)
	TO FILEGROUP OWA_INDEX
GO