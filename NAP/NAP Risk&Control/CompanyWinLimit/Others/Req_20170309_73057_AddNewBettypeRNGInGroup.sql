/*
	Created: 20170309@Helen
	Task: Script to add new bettype for RNG Casino in group
	DB:DBCUST/custdb
*/
USE CustDB
GO

DECLARE @GroupID INT, @ProductID INT = 6

SET @GroupID = (SELECT TOP 1 GroupID
			   FROM Winlimit_GameGroupSetting (NOLOCK)
				WHERE ProductID = @ProductID)

INSERT INTO Winlimit_GameGroupSetting (ProductID,BetTypeID,GroupID)
VALUES (@ProductID,2311,@GroupID)
	, (@ProductID,2312,@GroupID)
	, (@ProductID,2313,@GroupID)