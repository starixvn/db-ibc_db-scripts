/*
	Created by: Winnie
	Date: 2017-06-02
	Task: New agent cash balance - [Redmine: #74291]
	alter table dbo.CustSuper
	add the column IsAllDayBalTransfer 
	Server: DBCUST/CustDB	
*/ 

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB			--
------------------------------------------------------------------

USE [CustDB]
GO
  
ALTER TABLE [dbo].CustSuper ADD IsAllDayBalTransfer BIT NULL
GO

ALTER TABLE [dbo].CustSuper ADD  CONSTRAINT [DF_CustSuper_IsAllDayBalTransfer]  DEFAULT (0) FOR IsAllDayBalTransfer
GO
  