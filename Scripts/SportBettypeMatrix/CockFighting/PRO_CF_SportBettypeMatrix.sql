---DBPRO
Use bodb02
GO
 
 UPDATE  SportBettypeMatrix WITH (UPDLOCK, ROWLOCK)
 SET Istest = 0 
 WHERE ProductID = 19 
 