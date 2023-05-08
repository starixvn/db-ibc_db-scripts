/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20230427@Evan
	DB: DBN88-bodb_N88
	Task: Update keyvalue to updatetime for pull data by updatetime [RedmineID: #186791]
*/
USE bodb_N88
GO
DECLARE @id BIGINT; 

SELECT TOP 1 @id = id
FROM dbo.API_TimeTracker WITH (NOLOCK)
WHERE DataSource = 'WithdrawalInfo'  AND KeyValue IS NOT NULL
ORDER BY CalledTime DESC

UPDATE API_TimeTracker WITH(ROWLOCK) 
SET KeyValue = '2023-04-27 07:00:0.000'
WHERE Id = @id
GO

GO