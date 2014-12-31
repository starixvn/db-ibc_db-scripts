USE [bodb_TGRS]

GO
SET NOCOUNT ON

TRUNCATE TABLE [dbo].[Team]

INSERT INTO [dbo].[Team]([TeamName],[Description],[CreatedDate],[CreatedBy])
     VALUES
        ('Others','',GETDATE(),8),
		('Team A','',GETDATE(),8),
		('Team B','',GETDATE(),8),
		('Team C','',GETDATE(),8),
		('Team D','',GETDATE(),8),
		('Team E','',GETDATE(),8),
		('Team F','',GETDATE(),8),
		('Team G','',GETDATE(),8),
		('Team H','',GETDATE(),8),
		('Team I','',GETDATE(),8),
		('1X2','',GETDATE(),8),
		('BH','',GETDATE(),8)


INSERT INTO BetType(Bettype,TypeName,ORDERID)
SELECT * FROM (
	SELECT -16 Bettype,'Which team to Qualify' TypeName,61 ORDERID
	UNION ALL SELECT -17 Bettype,'Which team Winner' TypeName,62 ORDERID
	UNION ALL SELECT -18 Bettype,'Top Goal Scorer 1 vs 1 1st HDP & FT HDP' TypeName,71 ORDERID
	UNION ALL SELECT -19 Bettype,'Top Goal Scorer 1 vs 1 1st O/U & FT O/U' TypeName,72 ORDERID
	UNION ALL SELECT -20 Bettype,'Top Goal Scorer 2 vs 2 1st HDP & FT HDP' TypeName,73 ORDERID
	UNION ALL SELECT -21 Bettype,'Top Goal Scorer 2 vs 2 1st O/U & FT O/U' TypeName,74 ORDERID
	UNION ALL SELECT -22 Bettype,'First Goal' TypeName,81 ORDERID
	UNION ALL SELECT -23 Bettype,'Last Goal' TypeName,82 ORDERID
	UNION ALL SELECT -24 Bettype,'Penalty Shoot Out' TypeName,91 ORDERID
	UNION ALL SELECT -25 Bettype,'Last Throw In' TypeName,92 ORDERID
	UNION ALL SELECT -26 Bettype,'Fantasy Match' TypeName,93 ORDERID
	UNION ALL SELECT -27 Bettype,'Which Team Will Advance To Next Round' TypeName,94 ORDERID
	UNION ALL SELECT -28 Bettype,'OffSide' TypeName,95 ORDERID
	UNION ALL SELECT -29 Bettype,'Free Kick' TypeName,101 ORDERID
	UNION ALL SELECT -30 Bettype,'Goal Kick' TypeName,102 ORDERID
	UNION ALL SELECT -31 Bettype,'1st Handicap1st Over/Under' TypeName,111 ORDERID
	UNION ALL SELECT -32 Bettype,'Winner' TypeName,112 ORDERID
	UNION ALL SELECT -33 Bettype,' FANTASY MATCH - 1st OU /FT OU' TypeName,121 ORDERID
	UNION ALL SELECT -34 Bettype,' FANTASY MATCH - 1st HDP /FT HDP' TypeName,122 ORDERID
	UNION ALL SELECT -35 Bettype,'Full Time Team Total Goal' TypeName,131 ORDERID
	UNION ALL SELECT -36 Bettype,'First  Team Total Goal' TypeName,132 ORDERID
) tblA
WHERE Bettype NOT IN (SELECT BetType FROM BetType)