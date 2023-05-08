/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20230427@Evan
	DB: DBN88-bodb_N88
	Task: Update keyvalue to updatetime for pull data by updatetime [RedmineID: #186791]
*/
USE bodb_N88
GO
DECLARE @UpdateTime DATETIME,@CalledTime DATETIME; 
DECLARE @KeyValue INT; 

SELECT TOP 1 @KeyValue = CAST(KeyValue AS INT),
			@CalledTime = CalledTime
FROM dbo.API_TimeTracker WITH (NOLOCK)
WHERE DataSource = 'WithdrawalInfo'  AND KeyValue IS NOT NULL
ORDER BY CalledTime DESC

SELECT @UpdateTime = DATEADD(HOUR,-1,CreateTime) 
FROM WithdrawalInfo WITH(NOLOCK) 
WHERE WithdrawalId = @KeyValue

INSERT INTO API_TimeTracker (DataSource,CalledTime,KeyValue)
SELECT 'WithdrawalInfo', @CalledTime, CAST(@UpdateTime AS VARCHAR(200))

GO