/*
	Created by: Winnie
	Date: 2017-05-22
	Task: Color for closed Acc - [Redmine: #74494]
	alter table [CustLoginInfo],CustLoginInfo_Member,CustLoginInfoSub
	add the column ClosedReason 

*/ 
USE CustDB
GO
  
ALTER TABLE [dbo].[CustLoginInfo] ADD ClosedReason TINYINT NULL
GO
ALTER TABLE [dbo].CustLoginInfo_Member ADD ClosedReason TINYINT NULL
GO
ALTER TABLE [dbo].CustLoginInfoSub ADD ClosedReason TINYINT NULL
GO