/*<info serverAlias="DBPLO-MariaDB"></info>*/
/*
	Create: 20200820@Sol
	DB : DBPLO-MariaDB
	Task: remove tickets in MariaDB database (mysql server) [redmine: #139964]
*/

USE blueberrydb;

GO 

---- remove tickets
DELETE FROM blueberrydb.Betlogs where TransactionNo in (109533389853,109533433608,109533463709,109277806782,109560381545);
DELETE FROM blueberrydb.PlayerBets where TransactionNo in (109533389853,109533433608,109533463709,109277806782,109560381545);
DELETE FROM blueberrydb.WalletWins where TransactionNo in (109533389853,109533433608,109533463709,109277806782,109560381545);
DELETE FROM blueberrydb.WalletLosses where TransactionNo in (109533389853,109533433608,109533463709,109277806782,109560381545);

GO