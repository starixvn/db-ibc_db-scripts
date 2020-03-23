/*	
    Create : 20200323
	DB: DBPRO/bodb02
	Task: Indo 4D - sport / bettype local test  [Redmine: #130236]
*/
USE bodb02
GO

INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 5001, '4D',  5001,5001,'4D'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 5002, '3D',  5002,5002,'3D'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 5003, '2D Front',  5003,5003,'2D Front'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 5004, '2D Middle',  5004,5004,'2D Middle'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 5005, '2D Back',  5005,5005,'2D Back'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 5006, 'Colok Bebas',  5006,5006,'Colok Bebas'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 5007, 'Colok Jitu',  5007,5007,'Colok Jitu'


INSERT INTO  Sports  (Sporttype,SportName)VALUES (223,N'Indo 4D')
 
