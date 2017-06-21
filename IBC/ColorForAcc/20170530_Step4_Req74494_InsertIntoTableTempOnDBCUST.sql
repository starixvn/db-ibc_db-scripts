/*
	Created: Winnie	
	Task:  Insert into table temp on DBCUST
	DB: DBCUST/CUSTDB
	Date: 20170529
*/ 
USE [CustDB]
GO
TRUNCATE TABLE [TempClosedReason]
INSERT INTO [dbo].[TempClosedReason]
           ([CustID]
           ,[ClosedReason]
           ,[LogDate])
    SELECT [CustID]
           ,[ClosedReason]
           ,[LogDate]
FROM DBEXT.bodb02.dbo.[TempClosedReason]

TRUNCATE TABLE TempClosedReasonMember
INSERT INTO [dbo].TempClosedReasonMember
           ([CustID]
           ,[ClosedReason]
           ,[LogDate])
    SELECT [CustID]
           ,[ClosedReason]
           ,[LogDate]
FROM DBEXT.bodb02.dbo.TempClosedReasonMember