/*	
	Create : 20200322@Sophia
	Task: Sexy Gaming - Sporttype, Bettype[redmine: #130809]
	DB: DBPRO/bodb02
*/
USE bodb02
GO

INSERT INTO  Sports  (Sporttype,SportName)VALUES (243,N'Sexy Gaming')

INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc, typenamec_uni,typenamecn )   select 3101, 'Baccarat',  3101,3101,'Baccarat', N'百家樂', N'百家乐'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc, typenamec_uni,typenamecn )   select 3102, 'Dragon Tiger',  3102,3102,'Dragon Tiger', N'龍虎', N'龙虎'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc, typenamec_uni,typenamecn )   select 3103, 'Sicbo',  3103,3103,'Sicbo', N'骰寶', N'骰宝'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc, typenamec_uni,typenamecn )   select 3104, 'Roulette',  3104,3104,'Roulette', N'輪盤', N'轮盘'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc, typenamec_uni,typenamecn )   select 3105, 'Red Blue Duel',  3105,3105,'Red Blue Duel', N'紅藍對決', N'红蓝对决'

