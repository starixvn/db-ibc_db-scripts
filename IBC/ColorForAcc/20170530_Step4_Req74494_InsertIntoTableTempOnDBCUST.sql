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
           ,[LogID])
    SELECT [CustID]
           ,[ClosedReason]
           ,[LogID]
FROM DBEXT.bodb02.dbo.[TempClosedReason]

TRUNCATE TABLE TempClosedReasonMember
INSERT INTO [dbo].TempClosedReasonMember
           ([CustID]
           ,[ClosedReason]
           ,[LogID])
    SELECT [CustID]
           ,[ClosedReason]
           ,[LogID]
FROM DBEXT.bodb02.dbo.TempClosedReasonMember