/*
	Create: Helen
	Task: [Incident] - Missing Customer Setting - 19 Apr, 2017
	DB: DBCUST/CUSTDB
	
*/

DECLARE @UserName VARCHAR (200) = ''

CREATE TABLE #Cust_MissingSetting (username VARCHAR(200), isfinished bit default(0))

INSERT INTO #Cust_MissingSetting (username)
VALUES('JWL6789139'),
('JWL6789138'),
('JWL6789136'),
('SD8F0802005'),
('SJK652209002'),
('SD5F0102222'),
('SD831025245'),
('TV7E1221009'),
('HPVDM99987'),
('B6TKY77210'),
('DTC35D1'),
('FC132D0T002'),
('ZA940725X04'),
('SCHB20003'),
('DTC35DC01'),
('SCHB20002'),
('DX540411002'),
('BV391504000'),
('TY81240200J'),
('DX540411001'),
('S88DWW88260'),
('S88DWW88261'),
('S88DWW88262'),
('HDZ788123'),
('HDZ788000')

	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust_MissingSetting
	SET isfinished = 1
		,@UserName = username

	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.DBA_CustomerDel @UserName = @UserName
	
END
 
