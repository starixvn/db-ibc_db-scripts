/*
	Created: 20151127@Billy
	Task: Remove all functions and table that are used only in Virtual Rate Deployment (Non UM-Time)
	DB: DBCUST/CustDB & DBACC/bodb02
*/

IF EXISTS (SELECT OBJECT_ID('dbo.f_TransferVirtualSetting'))
	DROP FUNCTION dbo.f_TransferVirtualSetting
GO

IF EXISTS (SELECT OBJECT_ID('dbo.f_VirtualRateBitmapChecksum'))
	DROP FUNCTION dbo.f_VirtualRateBitmapChecksum
GO

IF EXISTS (SELECT OBJECT_ID('dbo.f_VirtualRateBitmapChecksum'))
	DROP FUNCTION dbo.f_VirtualRateBitmapChecksum
GO
