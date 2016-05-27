/*
	Created: Elodie
	Task: Offer for 2 currency WON & IDR
	DB: DBCUST/CustDB
	Date: 20160419
*/ 

DELETE FROM ProductStatusSiteCurrency WHERE SportType = 212 AND Currency IN (20, 4, 15, 22, 33, 34, 43, 44, 45, 47, 62) --'KRW', 'IDR', 'THB' 