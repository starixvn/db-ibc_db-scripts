USE bodb_licensee
GO

/*
	Create : 20171220@Harper
	Task : Enable Func Exchange Winloss for spondemo, 12bet, Alog [redmine:#86640]
*/

DECLARE @FunctionId INT,
		@LicenseeID INT,
		@RecordID INT = 1

DECLARE @LicenseeList TABLE (RecordID INT IDENTITY(1, 1), LicenseeId INT)

SELECT @FunctionId = FunctionId 
FROM [Functions] (NOLOCK) 
WHERE FunctionKey = 'ExchangeWinloss77'

INSERT INTO @LicenseeList(LicenseeId)
SELECT DISTINCT LicenseeId
FROM Licensees l WITH (NOLOCK)
WHERE l.LicenseeName IN ('spondemo', '12bet', 'Alog')

INSERT INTO LicenseeFunctions (LicenseeId, FunctionId)
SELECT LicenseeId, @FunctionID
FROM @LicenseeList

WHILE EXISTS(SELECT 1 FROM @LicenseeList WHERE RecordID = @RecordID)
BEGIN
	SELECT @LicenseeID = LicenseeID
	FROM @LicenseeList
	WHERE RecordID = @RecordID

	INSERT INTO LicenseeUserFunctions(UserId, FunctionId, LicenseeId)
	SELECT userid, @FunctionID, @LicenseeID
	FROM LicenseeUser WITH(NOLOCK)
	WHERE LicenseeID = @LicenseeID
		AND UserID NOT IN (SELECT UserId FROM LicenseeUserFunctions WITH(NOLOCK) WHERE LicenseeId = @LicenseeID AND FunctionId = @FunctionID)

	SET @RecordID = @RecordID + 1
END