/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 202105204@Kos
	DB: DBCUST-bodb_Licensee
	Task: Grant permission on function SpecialBA for testing [Redmine: #155702]
*/

USE bodb_Licensee
GO

DECLARE @ErrCode INT,
	@ErrMsg NVARCHAR(4000)

EXEC Lrf_LicenseeUserFunctionsIns @ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output,@UserId=11571,@LicenseeId=26,@FunctionId=54,@CustID=1414,@Langkey='en-US',@IP='127.0.0.1'
GO