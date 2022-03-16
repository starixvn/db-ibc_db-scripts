/*<info serverAlias="DBTXN-bodb02,DBACC-bodb02,DBAGE-bodb02,DBTP-bodb02,DBBAH-bodb02,DBBAL-bodb02" step="1"></info>*/
 
USE [master]
GO
ALTER DATABASE [bodb02] ADD FILEGROUP [Transfer_Table]
GO

USE [master]
GO
ALTER DATABASE [bodb02] ADD FILE ( NAME = N'Transfer_Table', FILENAME = N'D:\IBC_DB\bodb02\Transfer_Table.ndf' , SIZE = 3072KB , FILEGROWTH = 5120KB ) TO FILEGROUP [Transfer_Table]
GO




USE [master]
GO
ALTER DATABASE [bodb02] ADD FILEGROUP [Transfer_Index]
GO

USE [master]
GO
ALTER DATABASE [bodb02] ADD FILE ( NAME = N'Transfer_Index', FILENAME = N'D:\IBC_DB\bodb02\Transfer_Index.ndf' , SIZE = 3072KB , FILEGROWTH = 5120KB ) TO FILEGROUP [Transfer_Index]
GO


 