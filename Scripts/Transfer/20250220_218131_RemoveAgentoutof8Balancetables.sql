/*<info serverAlias="DBSIC-bodb02" isFunction="0" isNested=""></info>*/
/*
	Created: 20250220@Sophia
	DB: DBSIC.bodb02
	Task: remove agent out of 8 balance tables [Redmind: #218131]

*/

USE bodb02

GO
DELETE BalCreditTransfer WITH (UPDLOCK, ROWLOCK)
WHERE custID in ( 27994283 , 95433429 ) 

DELETE BalCreditCasino WITH (UPDLOCK, ROWLOCK)
WHERE custID in ( 27994283 , 95433429 ) 

DELETE BalCreditSports WITH (UPDLOCK, ROWLOCK)
WHERE custID in ( 27994283 , 95433429 ) 

DELETE BalCreditOthers WITH (UPDLOCK, ROWLOCK)
WHERE custID in ( 27994283 , 95433429 ) 


DELETE BalDebitTransfer WITH (UPDLOCK, ROWLOCK)
WHERE custID in ( 27994283 , 95433429 ) 

DELETE BalDebitCasino WITH (UPDLOCK, ROWLOCK)
WHERE custID in ( 27994283 , 95433429 ) 

DELETE BalDebitSports WITH (UPDLOCK, ROWLOCK)
WHERE custID in ( 27994283 , 95433429 ) 

DELETE BalDebitOthers WITH (UPDLOCK, ROWLOCK)
WHERE custID in ( 27994283 , 95433429 ) 