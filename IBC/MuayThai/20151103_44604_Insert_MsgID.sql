/*
	Description: A Script to insert new defined MsgID into MsgError table for new SP.
                 Please check for existed record before execute this script.
	Creator: 20151103@Billy
    DB: DBLOG.bodb_CustomerLog
*/

/* Check if the MsgIDs are existed in MsgError table
SELECT MsgID
FROM MsgError WITH(NOLOCK)
WHERE MsgID IN (60033, 60034)
*/

USE [bodb_CustomerLog]
GO


DECLARE @msg NVARCHAR(500)

SET @msg = 'Account disabled for this product. Unable to edit downlines.'
INSERT INTO [dbo].[MsgError] (
				MsgID, 
				MsgGroupID, 
				IsActive, 
				MsgNameEN, 
				MsgNameCT, 
				MsgNameCS, 
				MsgNameJP, 
				MsgNameTH, 
				MsgNameKO, 
				MsgNameES, 
				MsgNameVI)
VALUES	(		60033,
				7,
				1,
				@msg,
				@msg,
				@msg,
				@msg,
				@msg,
				@msg,
				@msg,
				@msg
		)

SET @msg = 'Cannot synchronize this product because this account''s upline not synchronize setting.'
INSERT INTO [dbo].[MsgError] (
				MsgID, 
				MsgGroupID, 
				IsActive, 
				MsgNameEN, 
				MsgNameCT, 
				MsgNameCS, 
				MsgNameJP, 
				MsgNameTH, 
				MsgNameKO, 
				MsgNameES, 
				MsgNameVI)
VALUES	(		60034,
				7,
				1,
				@msg,
				@msg,
				@msg,
				@msg,
				@msg,
				@msg,
				@msg,
				@msg
		)
GO