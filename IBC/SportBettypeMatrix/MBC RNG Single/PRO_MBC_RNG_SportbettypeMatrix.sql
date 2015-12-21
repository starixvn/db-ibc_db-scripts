---DBPRO
Use bodb02
GO
 
--Select *from SportBettypeMatrix Where Sporttype = 206   IN (4,16,6,30,206)

 

 UPDATE  SportBettypeMatrix WITH (UPDLOCK, ROWLOCK)
 SET Istest = 0 
 WHERE Sporttype IN (208,209,210) 