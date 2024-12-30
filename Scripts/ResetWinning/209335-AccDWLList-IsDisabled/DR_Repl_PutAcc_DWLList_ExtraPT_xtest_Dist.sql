/*<info serverAlias="DBCUST-CustDB" executers="repl_ap" isFunction="0" isNested="0"></info>*/
CREATE PROCEDURE [dbo].[DR_Repl_PutAcc_DWLList_ExtraPT_xtest_Dist]
    @tvp_param TVP_ReplAcc_DWLList_ExtraPT_xtest READONLY
AS
/*
	Created: 20241106@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
	Revisions:
		- 20241106@Lewis: Created [RedmineID: #000000]

	Example:			
*/
BEGIN
    SET NOCOUNT ON;
			
	INSERT INTO [dbo].[Acc_DWLList_ExtraPT_xtest_Del_InHouse]([CustId], [RepUpdateTime])
	SELECT [CustId], [RepUpdateTime]
	FROM (
		MERGE [dbo].[Acc_DWLList_ExtraPT_xtest] [t]
		USING @tvp_param [tvp] ON [t].[CustId] = [tvp].[CustId] 
		WHEN MATCHED AND [tvp].[isDeleted] = 0 THEN	
			UPDATE SET 
			    [t].[GroupId] = [tvp].[GroupId]
				,[t].[GroupName] = [tvp].[GroupName]
				,[t].[IsDisabled] = [tvp].[IsDisabled]
				,[t].[RepUpdateTime] = CASE WHEN [tvp].[RepUpdateTime] > ISNULL([t].[RepUpdateTime],'') THEN [tvp].[RepUpdateTime] ELSE [t].[RepUpdateTime] END
		WHEN MATCHED AND [tvp].isDeleted = 1 THEN
			DELETE
		WHEN NOT MATCHED AND [tvp].[isDeleted] = 0 THEN
			INSERT ([CustId]
				,[GroupId]
				,[GroupName]
				,[IsDisabled]
				,[RepUpdateTime])
			VALUES ([tvp].[CustId]
				,[tvp].[GroupId]
				,[tvp].[GroupName]
				,[tvp].[IsDisabled]
				,[tvp].[RepUpdateTime])
		OUTPUT $action, [deleted].[CustId], [tvp].[RepUpdateTime]
	) AS __deleting([Action], [CustId], [RepUpdateTime])
	WHERE [Action] = 'DELETE'; --only capture deleted $action
		
END	
GO
GRANT EXECUTE ON [dbo].[DR_Repl_PutAcc_DWLList_ExtraPT_xtest_Dist] TO [repl_ap]
GO