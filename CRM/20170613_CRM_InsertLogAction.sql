/*
	Created:	Winnie
	Date:		20170607
	Task :		update site/LicenseeType for multiple log [RedmineID:#77820]
	DB:			DB052.bodb_CRM
		
*/
USE [bodb_CRM]
GO

INSERT INTO [dbo].[crmLogAction]
           ([ActionID]
           ,[SPName]
           ,[ActionNameEN]
           ,[IsInternal])
     VALUES
           (704
           ,'Acc_CRM_GuestFeedbackUpd_Site_LicenseeType'
           ,'Update site and licenseetype for feedback'
           ,0)
GO


