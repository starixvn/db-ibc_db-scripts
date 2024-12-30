/*<info serverAlias="DBCUST-CustDB" executers="repl_ap" viewers="" isFunction="0"></info>*/

    SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Repl_GetAcc_DWLList_xtest]
    @start DATETIME2,
    @count INT,
    @back_fix INT = 0
AS
/*
	Created: 20241106@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
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
			FROM [dbo].[Acc_DWLList_xtest] WITH (NOLOCK, INDEX = IX_Acc_DWLList_xtest_RepUpdateTime)
			WHERE [RepUpdateTime] > @start AND [RepUpdateTime] < @__time_upperbound
			UNION ALL 
			SELECT [RepUpdateTime]
			FROM [dbo].[Acc_DWLList_xtest_Del_InHouse] WITH (NOLOCK)
			WHERE [RepUpdateTime] > @start AND [RepUpdateTime] < @__time_upperbound	
		) t
		ORDER BY [RepUpdateTime]
    )
    SELECT @__time_end = ISNULL(MAX([RepUpdateTime]), @start) FROM CTE_Timestamp;
	
	SET LOCK_TIMEOUT -1;
	
	IF @__time_end > @start
    BEGIN
		;WITH CTE AS(
        SELECT 
			[custid]
			,[product]
			,[seq]
			,[ProductId]
			,[IsDisabled]
			,[RepUpdateTime]
			,0 AS [isDeleted]
        FROM [dbo].[Acc_DWLList_xtest]  WITH (NOLOCK, INDEX = IX_Acc_DWLList_xtest_RepUpdateTime)
        WHERE [RepUpdateTime] > @__time_start AND [RepUpdateTime] <= @__time_end
        )
		SELECT 
			[custid]
			,[product]
			,[seq]
			,[ProductId]
			,[IsDisabled]
			,[RepUpdateTime]
			,0 AS [isDeleted]
			,SYSDATETIME() AS [_FetchedTime] 
		FROM CTE
		UNION ALL
		SELECT 
			[del].[custid]
			,[del].[product]
			,0 AS [seq]
			,0 AS [ProductId]
			,0 AS [IsDisabled]
			,MAX(RepUpdateTime) AS [RepUpdateTime]
			,1 AS [isDeleted]
			,SYSDATETIME() AS [_FetchedTime] 
		FROM [dbo].[Acc_DWLList_xtest_Del_InHouse] AS [del] WITH (NOLOCK)
		WHERE [RepUpdateTime] > @__time_start AND [RepUpdateTime] <= @__time_end
			AND NOT EXISTS( SELECT TOP 1 1 
							FROM CTE AS [c] 
							WHERE [c].[custid] = [del].[custid]
								AND [c].[product] = [del].[product]
								)
		GROUP BY [custid],[product] 	
		ORDER BY [RepUpdateTime]	
	END
END
GO
GRANT EXECUTE ON [dbo].[Repl_GetAcc_DWLList_xtest] TO [repl_ap]
GO