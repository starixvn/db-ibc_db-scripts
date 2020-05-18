/*

Created: 20200320@Sophia
Task: Saba.club integrate [redmine: #130372]
DB: DBPRO.bodb02

*/
use bodb02
go 

UPDATE SportBettypeMatrix 
SET IsTest = 1
WHERE Bettype BETWEEN 1643 AND 1699

 