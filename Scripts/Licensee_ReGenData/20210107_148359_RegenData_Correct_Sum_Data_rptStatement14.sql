 /*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Create : 20210107@Sol 
	Regen data for rptBetting - [Redmine: #148359] 
	DB: DBRPT.bodb_Report
*/

USE bodb_Report

GO

DECLARE @WinlostDate01 SMALLDATETIME = '2021-01-01'
DECLARE @WinlostDate02 SMALLDATETIME = '2021-01-02'
DECLARE @CustIds01 VARCHAR(MAX) = '47485411'
DECLARE @CustIds02 VARCHAR(MAX) = '47502469'

-- for '2021-01-01' , 47485411
EXEC dbo.Task_rptStatement_14
			@WinlostDate = @WinlostDate01,
			@CustIds = @CustIds01

-- for '2021-01-02' , 47502469
EXEC dbo.Task_rptStatement_14
			@WinlostDate = @WinlostDate02,
			@CustIds = @CustIds02
