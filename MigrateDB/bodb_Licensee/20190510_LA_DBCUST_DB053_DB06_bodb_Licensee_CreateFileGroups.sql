USE master
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.bodb_Licensee, DB053.bodb_Licensee, DB06.bodb_Licensee
	Task: Create new filegroups on bodb_Licensee
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

-- OWA_INDEX
ALTER DATABASE bodb_Licensee
	ADD FILEGROUP OWA_INDEX
GO

ALTER DATABASE bodb_Licensee
	ADD FILE
	(
		NAME = OWA_INDEX,  
		FILENAME = 'OWA_INDEX.ndf',  
		SIZE = 10MB,  
		MAXSIZE = 100MB,  
		FILEGROWTH = 5% 
	)
	TO FILEGROUP OWA_INDEX
GO

-- licensee_table
ALTER DATABASE bodb_Licensee
	ADD FILEGROUP licensee_table
GO

ALTER DATABASE bodb_Licensee
	ADD FILE
	(
		NAME = licensee_table,  
		FILENAME = 'licensee_table.ndf',  
		SIZE = 10MB,  
		MAXSIZE = 100MB,  
		FILEGROWTH = 5% 
	)
	TO FILEGROUP licensee_table
GO