USE [master]
GO
ALTER DATABASE [bodb_CustomerLog] ADD FILEGROUP [eaLogLogin]
GO
ALTER DATABASE [bodb_CustomerLog] ADD FILE ( NAME = N'eaLogLogin-01', FILENAME = N'H:\USER_DB\bodb_CustomerLog\eaLogLogin-01.ndf' , SIZE = 37888KB , FILEGROWTH = 10240KB ) TO FILEGROUP [eaLogLogin]
GO
ALTER DATABASE [bodb_CustomerLog] ADD FILEGROUP [eaLogUserCtrl]
GO
ALTER DATABASE [bodb_CustomerLog] ADD FILE ( NAME = N'eaLogUserCtrl-01', FILENAME = N'H:\USER_DB\bodb_CustomerLog\eaLogUserCtrl-01.ndf' , SIZE = 10240KB , FILEGROWTH = 10240KB ) TO FILEGROUP [eaLogUserCtrl]
GO
