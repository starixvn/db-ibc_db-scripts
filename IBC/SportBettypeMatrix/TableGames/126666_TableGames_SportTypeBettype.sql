use bodb02
GO 
/*
Create : 20200326@Sophia
Task: SportType/ Bettype local test Table Games [redmine :#126666]
DB: DBPRO.bodb02

*/

INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4901, 'Texas Poker, Win Three Card, Dragon Tiger, Bull, Blackjack, Baccarat and other games',  4901,4901,'Texas Poker, Win Three Card, Dragon Tiger, Bull, Blackjack, Baccarat and other games'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4902, 'Texas Poker',  4902,4902,'Texas Poker'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4903, 'Win Three Card',  4903,4903,'Win Three Card'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4904, 'Win Three Card 2',  4904,4904,'Win Three Card 2'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4905, 'Dragon Tiger',  4905,4905,'Dragon Tiger'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4906, 'Bull',  4906,4906,'Bull'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4907, 'Blackjack 16',  4907,4907,'Blackjack 16'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4908, 'Baccarat',  4908,4908,'Baccarat'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4909, 'Baccarat 2',  4909,4909,'Baccarat 2'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4910, 'Three Picture',  4910,4910,'Three Picture'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4911, 'Teen Patti',  4911,4911,'Teen Patti'
INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 4912, 'Andar Bahar',  4912,4912,'Andar Bahar'

INSERT INTO  Sports  (Sporttype,SportName)VALUES (222,N'Table Games')

 