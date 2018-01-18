USE CustDB
GO

/*
	Created: 20171110@Harper
	Description: Initialize data for ExVirtualRate [RedmineID: #82408]
*/

UPDATE dbo.exchange
SET ExVirtualRate = 0.01
WHERE exchangeid IN (20)--, 61) -- UUS

--UPDATE dbo.exchange
--SET ExVirtualRate = 1
--WHERE exchangeid = 3

-- SELECT exchangeId, currency, code, ExVirtualRate FROM exchange WITH (NOLOCK) WHERE Code = 'USD'