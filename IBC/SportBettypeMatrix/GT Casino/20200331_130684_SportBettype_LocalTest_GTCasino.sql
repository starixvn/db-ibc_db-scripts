Use bodb02
GO 
/*
Create : 20200331@Sophia 
Task: Sport/bettype of GT - local test [redmineID: #130684]
DB: DBPRO.bodb02
*/


INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 3201, 'Baccarat',  3201,3201,'Baccarat'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 3202, 'Dragon Tiger',  3202,3202,'Dragon Tiger'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 3203, 'SicBo',  3203,3203,'SicBo'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 3204, 'Roulette',  3204,3204,'Roulette'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 3205, 'Bull Bull',  3205,3205,'Bull Bull'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 3206, 'This Bar',  3206,3206,'This Bar'


INSERT INTO  Sports  (Sporttype,SportName)VALUES (242,N'GT Casino')
