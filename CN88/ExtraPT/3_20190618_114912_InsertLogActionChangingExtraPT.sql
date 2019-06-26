/*
	Created by: Sophia
	Date: 20190620
	Task: Insert LogAction for Change Group ExtraPT for Super  [redmind: 114912]
	DB: DBLOG/bodb_CustomerLog
*/
USE [bodb_CustomerLog]
GO
 

DECLARE @tmpAction TABLE (ActionID INT, ActionName NVARCHAR(256), SPName VARCHAR(50), IsInternal BIT, ActionTypeId INT, Level TINYINT)
INSERT INTO @tmpAction (ActionID, ActionName, SPName, IsInternal, ActionTypeId, Level)
SELECT	160009, 'Change Extra PT Group for Super', 'CS_GroupExtraPT_Upd', 1, 4, NULL  

INSERT INTO dbo.LogAction (ActionID,SPName,ActionTypeID,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI,ActionNameCN)
SELECT ActionID,SPName,ActionTypeID,ActionName,ActionName,ActionName,ActionName,ActionName,ActionName,IsInternal,ActionName,ActionName
FROM @tmpAction t
WHERE NOT EXISTS (SELECT 1 FROM LogAction WHERE ActionID = t.ActionID)

