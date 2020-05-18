USE bodb02
GO

/*
	Created: 20200212@Malcolm
	DB: DBPRO.bodb02
	Task: New bettype: Collor ball [Redmine : #128101]
*/

INSERT INTO Bettype (TypeId, TypeNamee,ParentTypeid, DisplayedTypeID,typedesc )   select 91, 'Next R/B',  91,91,'Next R/B'