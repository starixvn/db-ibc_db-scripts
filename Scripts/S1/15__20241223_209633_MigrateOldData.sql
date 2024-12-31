/*<info serverAlias="DBWLB-bodb_WhiteLabel"></info>*/
/*
	Created: 20241223@Danny
	DB:DBWLB-bodb_WhiteLabel
	Task: Migrate old data RedmineId #209633
*/

GO

use bodb_WhiteLabel

-- 337 rows

INSERT INTO WhiteLabelWinloss (CustID,Recommend,	MRecommend,	SRecommend,	WinlostDate,	CurrencyID,	Winloss,	TypeId,	GameProviderCode,	ModifiedDate)
SELECT CustID,Recommend,	MRecommend,	SRecommend,	WinlostDate,	CurrencyID,	Winloss,	TypeId,	GameProviderCode,	ModifiedDate
FROM bodb02.dbo.WhiteLabelWinloss WITH(NOLOCK)
WHERE CustID IN (169659405,169660506)