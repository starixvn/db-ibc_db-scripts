USE [bodb02]
GO

/*
	Created: 20181109@Percy
	DB: DBTXN.bodb02
	Task: Delete record from balance tables for SMA
	
	-- SMA list:
	custid		username	        roleid
	7273971		JK33	            3
	26912829	SupertestTE1001		3
*/

-- transfer
DELETE TOP (3) BalCreditTransfer WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (7273971,26912829)

DELETE TOP (3) BalDebitTransfer WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (7273971,26912829)

-- sports
DELETE TOP (3) BalCreditSports WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (7273971,26912829)

DELETE TOP (3) BalDebitSports WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (7273971,26912829)

-- casino
DELETE TOP (3) BalCreditCasino WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (7273971,26912829)

DELETE TOP (3) BalDebitCasino WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (7273971,26912829)

-- others
DELETE TOP (3) BalCreditOthers WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (7273971,26912829)

DELETE TOP (3) BalDebitOthers WITH (ROWLOCK, UPDLOCK)
WHERE custid IN (7273971,26912829)