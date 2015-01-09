USE bodb_licensee
GO
/*
Created: 20150107@Jim
Task :  Enhance LRF to allow licensee that doesn't have Sportsbook
DB:     DBLIC/bodb_licensee
Original:
Revisions:
*/
INSERT INTO dbo.Product3rd (Productid,ProductName,Description,ProductPrefix)
SELECT 0 			AS Productid
	   ,'Sportbook' AS ProductName
	   ,'Sportbook' AS Description
	   ,'SB'	    AS ProductPrefix