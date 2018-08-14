/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DBCUST
*/
-- Production --
CREATE DATABASE [NAP_UserControl] ON  PRIMARY 
( NAME = N'NAP_UserControl_Primary', FILENAME = N'H:\USER_DB\NAP_UserControl\Primary.MDF' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB ), 
 FILEGROUP [NAP_UserControl_table] 
( NAME = N'NAP_UserControl_table_01', FILENAME = N'D:\USER_DB\NAP_UserControl\NAP_UserControl_table_01.NDF' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB )

/*
-- Local Test
CREATE DATABASE [NAP_UserControl] ON  PRIMARY 
( NAME = N'NAP_UserControl_Primary', FILENAME = N'D:\DB233\IBC_DB\NAP_UserControl\Primary.MDF' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB ), 
 FILEGROUP [NAP_UserControl_table] 
( NAME = N'NAP_UserControl_table_01', FILENAME = N'D:\DB233\IBC_DB\NAP_UserControl\NAP_UserControl_table_01.NDF' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB )

-- Local Dev 
CREATE DATABASE [NAP_UserControl] ON  PRIMARY 
( NAME = N'NAP_UserControl_Primary', FILENAME = N'E:\SQLSERVER2008R2\IBC_DB\NAP_UserControl\Primary.MDF' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB ), 
 FILEGROUP [NAP_UserControl_table] 
( NAME = N'NAP_UserControl_table_01', FILENAME = N'E:\SQLSERVER2008R2\IBC_DB\NAP_UserControl\NAP_UserControl_table_01.NDF' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB )
*/

