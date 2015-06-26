/*
redmineID :  #38514
Licensee site ID 175- Be transferred to Boping
*/
USE bodb_licensee
GO
DECLARE @LicenseeID INT
SELECT @LicenseeID = LicenseeID
FROM dbo.Licensees WITH (NOLOCK)
WHERE LicenseeName='DUOLE'
 
SELECT @LicenseeID
 
UPDATE LicenseeReseller WITH (ROWLOCK,UPDLOCK)
SET ResellerID = 7 --Boping
WHERE LicenseeID = @LicenseeID
	AND ResellerID<> 3
	
DELETE LicenseeProduct3rd
WHERE LicenseeID = @LicenseeID
	AND ProductID = 1 --- 1	Racing
	
DELETE LicenseeFunctions
WHERE LicenseeId = @LicenseeID
	AND FunctionId IN (SELECT FunctionId FROM Functions WITH (NOLOCK)
						WHERE FunctionId IN 
								(
									22	--- Racing		1	TotalBets/HorseRacing
									,35 ---	Daily Racing Win Loss		3	Report/DailyRacingWinLoss
									,34	---Racing Commission		3	Report/RacingCommission
			
								)
						)	
						
						
						 

 