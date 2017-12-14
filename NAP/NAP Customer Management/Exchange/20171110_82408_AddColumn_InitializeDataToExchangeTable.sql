USE CustDB
GO

/*
	Created: 20171110@Harper
	Description: Add column on Exchange table and initialize data for it [RedmineID: #82408]
*/

-- Add New Column 
ALTER TABLE dbo.exchange ADD ExVirtualRate FLOAT

-- Insert Setting data

/*	
	1INR: 0.01 P; 1USD = 1 U ;1UUS: 0.01 P	
*/

UPDATE dbo.exchange
SET ExVirtualRate = 0.01
WHERE exchangeid IN (20, 61)

UPDATE dbo.exchange
SET ExVirtualRate = 1
WHERE exchangeid = 3

-- SELECT exchangeId, currency, code, ExVirtualRate FROM exchange WITH (NOLOCK) WHERE Code = 'USD'