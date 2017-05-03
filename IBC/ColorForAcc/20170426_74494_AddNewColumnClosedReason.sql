USE CustDB
GO
  
ALTER TABLE [dbo].[CustLoginInfo] ADD ClosedReason TINYINT NULL
GO
ALTER TABLE [dbo].CustLoginInfo_Member ADD ClosedReason TINYINT NULL
GO
ALTER TABLE [dbo].CustLoginInfoSub ADD ClosedReason TINYINT NULL
GO