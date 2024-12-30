/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="repl_ap" isFunction="0" isNested="0"></info>*/

    SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Repl_PutAcc_DWLList_ExtraPT_xtest_Dist]
    @tvp_param TVP_ReplAcc_DWLList_ExtraPT_xtest READONLY
AS
/*
	Created: 20241106@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
	
	Revisions:
		- 20241106@Lewis: Scale out DBCUST [RedmineID: #000000]

	Example:			
*/
BEGIN
    SET NOCOUNT ON;
			
    MERGE [dbo].[Acc_DWLList_ExtraPT_xtest] [t]
    USING @tvp_param [tvp] 
		ON [t].[CustId] = [tvp].[CustId]
		WHEN MATCHED THEN	
		UPDATE SET
			[t].[GroupId] = [tvp].[GroupId]
			,[t].[GroupName] = [tvp].[GroupName]
			,[t].[IsDisabled] = [tvp].[IsDisabled]
			,[t].[RepUpdateTime] = CASE WHEN [tvp].[RepUpdateTime] > ISNULL([t].[RepUpdateTime],'') THEN [tvp].[RepUpdateTime] ELSE [t].[RepUpdateTime] END	
			,[t].[isDeleted]= [tvp].[isDeleted]
    WHEN NOT MATCHED THEN
        INSERT ([CustId]
				,[GroupId]
				,[GroupName]
				,[IsDisabled]
				,[RepUpdateTime]
		   		,[isDeleted])
		VALUES ([tvp].[CustId]
				,[tvp].[GroupId]
				,[tvp].[GroupName]
				,[tvp].[IsDisabled]
				,[tvp].[RepUpdateTime]
				,[tvp].[isDeleted] 
		);
		
END	
GO
GRANT EXECUTE ON [dbo].[Repl_PutAcc_DWLList_ExtraPT_xtest_Dist] TO [repl_ap]
GO