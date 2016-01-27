/*
	Created: 20151230@Elodie
	Task: Update BalanceType in Product table to refer information
*/

GO
UPDATE p
SET p.BalanceType = CASE WHEN ProductID = 1 THEN 1
						 WHEN ProductID IN (4,6,10,11,12,13,17) THEN 3
						 WHEN ProductID IN (2,3,5,8,15,18,19) THEN 4 END
FROM Products p WITH (ROWLOCK,UPDLOCK)

GO
DECLARE @SubProduct TABLE (Name VARCHAR(20), BalanceType INT)
DECLARE @SubProductBalanceType VARCHAR(500)

INSERT INTO @SubProduct (Name, BalanceType) 
VALUES ('BetRadar', 1),('BetTrade', 1),('MuayThai', 1),('MyanmarOdds', 1),('SporttingSolutions', 1), ('MG-SuperLive', 4)

SELECT	@SubProductBalanceType = CONVERT(VARCHAR(500), (	SELECT																											
															(
																SELECT 	new.Name AS '@N',
																		new.BalanceType AS '@T'																	
																FROM	@SubProduct new
																FOR XML PATH ('SP'),
																TYPE
															)
													FOR XML PATH ('BalType'),
													TYPE
													))
--SELECT @SubProductBalanceType

UPDATE Products
SET SubProductBalanceType = @SubProductBalanceType
WHERE ProductID = 1

--Create view on DBTXN/DB053/DB06
USE bodb02
GO 
CREATE VIEW ProductBalanceType
AS
	WITH tmp AS (
		SELECT ProductID, x AS SubProductBalanceType
		FROM Products p
		CROSS APPLY (
			SELECT CONVERT(XML,SubProductBalanceType)
			FROM Products WITH(NOLOCK)
			WHERE ProductID = p.ProductID
			FOR XML PATH(''), TYPE
		) a(x)
		WHERE SubProductBalanceType <> ''
	)
	SELECT tmp.ProductID, sub.Name AS ProductName, sub.BalanceType AS BalanceTypeID,
					CASE	WHEN BalanceType = 1 THEN 'SportsBook'
							WHEN BalanceType = 3 THEN 'Casino'
							WHEN BalanceType = 4 THEN 'Others' 
							ELSE '' END AS BalanceType,
					1 AS IsSubProduct
	FROM tmp 
		CROSS APPLY (
					SELECT	r.value('./@N','VARCHAR(20)') AS Name,
							r.value('./@T','TINYINT') AS BalanceType
					FROM SubProductBalanceType.nodes('//BalType/SP') AS RECORDS(r)) sub
	UNION ALL
	SELECT ProductID, ProductName, BalanceType AS BalanceTypeID, 
		CASE	WHEN BalanceType = 1 THEN 'SportsBook'
				WHEN BalanceType = 3 THEN 'Casino'
				WHEN BalanceType = 4 THEN 'Others' 
				ELSE '' END AS BalanceType,
		0 AS IsSubProduct
	FROM dbo.Products
GO

SELECT * FROM ProductBalanceType ORDER BY ProductID, IsSubProduct


