---DBPRO
Use bodb02
GO

--Select *from Products  

--Select *from SportBettypeMatrix Where Sporttype = 206   IN (4,16,6,30,206)


INSERT INTO Products (ProductID, ProductName, Description, Enabled, ProductPrefix)
VALUES (19, 'Cockfighting','Cockfighting', 1, 'CF')


INSERT INTO SportBettypeMatrix (SportType,BetType,IsLive,ProductID,Enabled,IsTest,EventType,SubProduct)
VALUES (206,1003,0,19,1,1,0,'')
 
  
 

  
   