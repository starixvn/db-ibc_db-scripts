/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20220919@Sol
	DB: DBLIC-bodb_3rdProduct
	Task: update old data - [Redmine: #177979]
*/

--## RUN IN DB052 ONLY ##--

USE bodb_3rdProduct

GO 

;WITH rs
AS (
	SELECT *
	FROM (
			VALUES 
				(6580,'2021-09-28 00:00:00.000'),
				(6599,'2021-09-30 00:00:00.000'),
				(7010,'2021-12-29 00:00:00.000'),
				(17181,'2022-01-28 00:00:00.000'),
				(17620,'2022-03-24 00:00:00.000'),
				(27989,'2022-06-29 00:00:00.000'),
				(28180,'2022-07-13 00:00:00.000')
		) AS t(id, winlostdate)
	)

UPDATE his
	SET his.SumToThirdPartyDate = rs.WinlostDate
FROM bodb_3rdProduct.dbo.Product3rd_SummarizedDateHistory AS his
	INNER JOIN rs
		ON rs.id = his.ID AND rs.winlostdate = his.WinlostDate
WHERE his.ProductID = 31

GO