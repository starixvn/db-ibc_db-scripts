USE bodb_licensee
GO
/*
Created: 20150107@Jim
Task :  Enhance LRF to allow licensee that doesn't have Sportsbook
DB:     DBLIC/bodb_licensee
Original:
Revisions:
*/
DECLARE @tblFunction AS TABLE (FunctionID INT)
DECLARE @LicenseeID INT
INSERT INTO @tblFunction (FunctionID )
SELECT FunctionID 
FROM dbo.Functions WITH (NOLOCK)
WHERE FunctionId IN ( --LC
					 3  -- REPORTS
					,27 -- Licensee Win Loss
					,28 -- Settled Match Count
					,31 -- Match Win Loss
					,32 -- Win Loss By Products
					,33 -- Win Loss By Bet Type
					,36 -- Cancelled Bets
					,37 -- Daily Bet List
					,38 -- Live Report
					,39 -- Turnover
					,52 -- CUSTOMER REPORTS
					,53 -- Mobile Win Loss
					,41 -- Results
					,42 -- Balance
					,29 -- Customer Win Loss
					,30 -- Customer Pending Funds
					,40 -- Customer Balance
					 )	
OR ParentId IN (4,6)						

SELECT @LicenseeId = LicenseeID
FROM dbo.Licensees WITH (NOLOCK) 
WHERE LicenseeName = 'Doctorgame'

IF ISNULL (@LicenseeId,0)=0
 BEGIN	
	 PRINT 'This Licensee is not exist,plz have a check'
	 RETURN;
 END
 
DELETE 	dbo.LicenseeFunctions 
WHERE LicenseeId = @LicenseeID 
	AND FunctionID NOT IN (  
						  SELECT FunctionId FROM @tblFunction
					   	 )	

DELETE 	dbo.LicenseeUserFunctions
WHERE LicenseeID = @LicenseeId 
	AND FunctionID NOT IN (  
						  SELECT FunctionId FROM @tblFunction
					   	 )	
				
