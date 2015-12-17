Use bodb02
GO

--Select *from Products  

--Select *from SportBettypeMatrix Where Bettype  IN (4,16,6,30,126)


INSERT INTO Products (ProductID, ProductName, Description, Enabled, ProductPrefix)
VALUES (18, 'Binary Options','Binary Options', 1, 'BO')


INSERT INTO SportBettypeMatrix (SportType,BetType,IsLive,ProductID,Enabled,IsTest,EventType,SubProduct)
VALUES (200,1401,0,1,1,1,1,'')
, (200,1402,0,1,1,1,1,'') 
, (200,1403,0,1,1,1,1,'') 

