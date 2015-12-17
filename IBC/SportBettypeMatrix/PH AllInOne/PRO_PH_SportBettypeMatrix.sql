---DBPRO
Use bodb02
GO

 UPDATE  SportBettypeMatrix WITH (UPDLOCK, ROWLOCK)
 SET Istest = 0 
 WHERE Bettype IN (401,402,403,404,405,406,407,408,409,410,411,412)
 OR  ( Bettype IN (4,16,6,30,126) AND IsTest = 1)
 