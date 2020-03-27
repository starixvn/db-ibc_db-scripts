/*
	Created by: Kos
	Date: 20200327
	Task: Change username of sa [RedmineID: #129873]
	DB: DBCUST.N88_UserControl
*/

USE [N88_UserControl]
GO

UPDATE [dbo].[N88_Users] WITH (ROWLOCK, UPDLOCK)
SET Username = 'starix1'
WHERE UserID = 1000001
