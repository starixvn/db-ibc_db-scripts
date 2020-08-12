/*<info serverAlias="DBPLO-bodb_Ploutos"></info>*/
/*
	Create: 20200811@Sol
	DB : DBPLO-bodb_Ploutos
	Task: update statusid and playercode3rd to initial value for re-sync [redmine: #139383]
*/

USE bodb_Ploutos;

GO

DECLARE @Users TABLE (UserName VARCHAR(30))

INSERT INTO @Users(UserName)
SELECT *
FROM
	(
		VALUES 
			('77vx99')
			,('apxxxxgq')
			,('boxxqxsg')
			,('Bxxxyxx99')
			,('Chcxxxxxxx56')
			,('dexxxxxx75')
			,('Edxxg23')
			,('Emxxoi')
			,('Hnxxxxxxx76')
			,('Hoxxxxuvu')
			,('huexxjx23')
			,('kaxxxxxxuxxxov')
			,('Kiimxan')
			,('loxxxxxg91')
			,('LTxxxp65')
			,('mixxxeo1')
			,('MSxxxxxx43')
			,('paxxlxx58')
			,('quxxxxxxxxxx71')
			,('Raxyai')
			,('Rexxbxx19')
			,('sexrxxxxar')
			,('shxxxxxxxtx81')
			,('smxvx11')
			,('Srxxxxxkxha')
			,('Srxxxxxxxxxxxxxxxxar')
			,('taxxnxx86')
			,('Thxxxxxwxx88')
			,('Tuxxxxa64')
			,('Xaoxxxxx90')
			,('yhxxxxxbb')
	) t (UserName)

---- 31 rows
SELECT * FROM @Users

---- update PlayerProfile table
---- 31 rows affected

UPDATE PlayerProfile WITH(ROWLOCK)
	SET StatusID = 0,
		PlayerCode3rd = NULL,
		TryCount = 0
WHERE Username IN (SELECT UserName FROM @Users)
	AND BrandCode = '12BET'

---- update BetTicket table
UPDATE b 
	SET StatusID = 0,
		TryCount = NULL
FROM BetTicket b WITH(ROWLOCK)
	INNER JOIN PlayerProfile p WITH(NOLOCK)
		ON b.CustId = p.CustID AND b.BrandCode = p.BrandCode
WHERE 
	b.StatusID = 3
	AND Username IN (SELECT UserName FROM @Users)
	AND p.BrandCode = '12BET'

GO