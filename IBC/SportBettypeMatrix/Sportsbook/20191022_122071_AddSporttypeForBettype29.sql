use bodb02
GO 

/*
Create: 20191022@Sophia
Task: Add more sporttype for bettype 29 [redmine: #122071]
DB: DBPRO.bodb02
*/


SELECT *
INTO #T
FROM Sportbettypematrix WITH (NOLOCK) 
WHERE bettype = 9 and sporttype NOT IN (SELECT Sporttype FROM  sportbettypematrix WHERE bettype = 29)


INSERT INTO Sportbettypematrix 
(	SportType,
	BetType,
	IsLive,
	ProductID,
	Enabled,
	IsTest,
	EventType,
	SubProduct,
	RefTable)
SELECT SportType,
	29 AS BetType,
	IsLive,
	ProductID,
	Enabled,
	IsTest,
	EventType,
	SubProduct,
	RefTable
FROM #T 
 