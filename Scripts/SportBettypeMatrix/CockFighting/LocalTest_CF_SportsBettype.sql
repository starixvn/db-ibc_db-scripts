--- DBPRO
use bodb02

Select * from Sports

UPDATE Sports 
SET SportName = 'Cockfighting'
WHERE Sporttype = 206 



UPDATE Bettype 
SET typenamee = 'Cockfighting',
typenamec = 'Cockfighting'
WHERE TypeId = 1003  