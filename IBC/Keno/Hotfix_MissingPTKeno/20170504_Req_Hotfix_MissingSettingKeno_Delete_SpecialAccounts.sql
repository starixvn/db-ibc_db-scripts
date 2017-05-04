/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - Delete special accounts- [Redmine: 76020]
	DB:DBCUST/CUSTDB
*/

USE CustDB
GO
DECLARE @UserName VARCHAR (200) = ''

CREATE TABLE #Cust_MissingSetting (username VARCHAR(200), isfinished bit default(0))

INSERT INTO #Cust_MissingSetting (username)
VALUES
('QW107AA121'),
('TVA96QG82'),
('TY81H104'),
('PYH026V020'),
('SSMA9322833')

DECLARE @ErrCode int = 0,
	@ErrMsg varchar(200) = ''
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust_MissingSetting
	SET isfinished = 1
		,@UserName = username

	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.DBA_CustomerDel @UserName = @UserName, @ErrCode = @ErrCode OUTPUT, @ErrMsg= @ErrMsg OUTPUT
	
END
 

