/*
	Created:20171019@Kathy
	DB: DBTXN/bodb02
	Task: Check data before updating setting
*/

USE bodb02
GO

DECLARE @cutoffdate			SMALLDATETIME
	,@newHouseDeductionRate	SMALLMONEY
	,@newHousePT			MONEY

	,@oldHouseDeductionRate	SMALLMONEY
	,@oldHousePT			MONEY

SELECT	@cutoffdate = '2017-11-01'		
		,@newHouseDeductionRate = 0.03
		,@newHousePT = 1

		,@oldHouseDeductionRate = 0.015
		,@oldHousePT = 0.5

IF EXISTS (SELECT	TOP 1 1
			FROM	dbo.bettrans b WITH(NOLOCK)
			WHERE	b.winlostdate >= @cutoffdate
					AND bettype BETWEEN 912 AND 913
					AND 1 = CASE
								WHEN b.bettype = 912 AND oddsspread <> @newHousePT THEN 1
								WHEN b.bettype = 913 AND odds <> @newHouseDeductionRate THEN 1 					
								ELSE 0
							END
)
BEGIN
	SELECT 'There are some tickets (winlostdate >= ' + CAST(@cutoffdate AS VARCHAR(20)) + ' ) have OLD setting value' AS Message

END

IF EXISTS (SELECT	TOP 1 1
			FROM	dbo.bettrans b WITH(NOLOCK)
			WHERE	b.winlostdate < @cutoffdate
					AND bettype BETWEEN 912 AND 913
					AND 1 = CASE
								WHEN b.bettype = 912 AND oddsspread <> @oldHousePT THEN 1
								WHEN b.bettype = 913 AND odds <> @oldHouseDeductionRate THEN 1 					
								ELSE 0
							END
)
BEGIN
	SELECT 'There are some tickets (winlostdate < ' + CAST(@cutoffdate AS VARCHAR(20)) + ' ) have NEW setting value' AS Message

END
