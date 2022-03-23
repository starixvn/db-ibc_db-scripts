 /*<info serverAlias="DBAFFN88-Affiliate_N88"></info>*/
/*
	Created: 20220322@Malcolm
	DB: DBAFFN88-Affiliate_N88 [RedmineID:170289]
	Task: update data
*/


UPDATE SystemSettings WITH(ROWLOCK)
	SET SValue = '2:MYR,4:THB,15:IDR,13:CNY,61:INR'
WHERE SName = 'AFF_PaymentCurrencies'

UPDATE SystemSettings WITH(ROWLOCK)
	SET SValue = '2:MYR,4:THB,13:CNY,15:IDR,61:INR'
WHERE SName = 'AFF_SupportedCurrencies'