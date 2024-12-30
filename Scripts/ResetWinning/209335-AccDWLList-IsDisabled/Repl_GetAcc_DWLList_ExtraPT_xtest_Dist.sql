/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="repl_ap" isFunction="0" isNested="0"></info>*/

    SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Repl_GetAcc_DWLList_ExtraPT_xtest_Dist]
    @start DATETIME2,
    @count INT,
    @back_fix INT = 0
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

    DECLARE @__time_start DATETIME2 = DATEADD(MILLISECOND, -@back_fix, @start);
    DECLARE @__time_end DATETIME2;
    DECLARE @__time_upperbound DATETIME2 = DATEADD(MILLISECOND, [dbo].[f_GetUpperBound_BackFix](), SYSDATETIME());

    SET LOCK_TIMEOUT 1000;
	
	
   ; WITH CTE_Timestamp ([RepUpdateTime]) AS (
        SELECT TOP (@count) [RepUpdateTime]
		FROM(
			SELECT [RepUpdateTime]
			FROM [dbo].[Acc_DWLList_ExtraPT_xtest] WITH (NOLOCK, INDEX = IX_Acc_DWLList_ExtraPT_xtest_RepUpdateTime)
			WHERE [RepUpdateTime] > @start AND [RepUpdateTime] < @__time_upperbound			
		) t
		ORDER BY [RepUpdateTime]
    )
    SELECT @__time_end = ISNULL(MAX([RepUpdateTime]), @start) FROM CTE_Timestamp;
	
	SET LOCK_TIMEOUT -1;
	
	IF @__time_end > @start
    BEGIN		
        SELECT 
			[CustId]
			,[GroupId]
			,[GroupName]
			,[IsDisabled]
			,[RepUpdateTime]
			,ISNULL([isDeleted],0) AS [IsDeleted]
			,SYSDATETIME() AS [_FetchedTime]
        FROM [dbo].[Acc_DWLList_ExtraPT_xtest]  WITH (NOLOCK, INDEX = IX_Acc_DWLList_ExtraPT_xtest_RepUpdateTime)
        WHERE [RepUpdateTime] > @__time_start AND [RepUpdateTime] <= @__time_end
		ORDER BY [RepUpdateTime]
    END
END
GO
GRANT EXECUTE ON [dbo].[Repl_GetAcc_DWLList_ExtraPT_xtest_Dist] TO [repl_ap]
GO