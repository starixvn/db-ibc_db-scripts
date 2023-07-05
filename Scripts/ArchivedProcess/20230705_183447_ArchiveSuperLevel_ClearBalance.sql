/*<info serverAlias="DBCTG-bodb02" executers="" selecters="" viewers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20200505@Danny
	Task: Clear archived super balance
	DB: DBCTG-bodb02
*/
USE bodb02
GO
SET NOCOUNT ON
BEGIN
	CREATE TABLE #super(custID INT, ID INT Identity(1,1), ErrMsg NVARCHAR(200), ErrCode INT)

	INSERT INTO #super(custID)
	SELECT custID FROM DBCUST.CustDB.dbo.Cust_ArchiveAccount WITH(NOLOCK) WHERE roleid = 4 and stageid = 3

	DECLARE @i			INT = 1 , 
			@CustID		INT, 
			@ErrMsg		NVARCHAR(200), 
			@ErrCode	INT	= 0 

	WHILE EXISTS (SELECT TOP 1 1 FROM #super WHERE ID = @i)
	BEGIN
		SELECT @CustID = CustID FROM #super WHERE ID = @i

		EXEC DBA_ArchiveAccount3_ClearBalance_Super @srecommend = @CustID,
													@UserID		= 360418,  --starix1
													@ErrMsg		= @ErrMsg  OUTPUT,
													@ErrCode	= @ErrCode OUTPUT
			
		UPDATE #super  
		SET ErrMsg = @ErrMsg, ErrCode= @ErrCode
		WHERE ID = @i

		SELECT @i = @i + 1
	END

	-- SHow all result
	SELECT * FROM #super
	DROP TABLE #super

END
GO
