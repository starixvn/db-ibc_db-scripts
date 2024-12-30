/*<info serverAlias="DBCUST-CustDB" executers="repl_ap" isFunction="0" isNested="0"></info>*/
CREATE PROCEDURE [dbo].[DR_Repl_PutAcc_DWLList_xtest_Dist]
    @tvp_param TVP_ReplAcc_DWLList_xtest READONLY
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
			
	INSERT INTO [dbo].[Acc_DWLList_xtest_Del_InHouse]([custid], [product], [RepUpdateTime])
	SELECT [custid], [product], [RepUpdateTime]
	FROM (
		MERGE [dbo].[Acc_DWLList_xtest] [t]
		USING @tvp_param [tvp] ON [t].[custid] = [tvp].[custid] AND [t].[product] = [tvp].[product] 
		WHEN MATCHED AND [tvp].[isDeleted] = 0 THEN	
			UPDATE SET 
			    [t].[seq] = [tvp].[seq]
				,[t].[ProductId] = [tvp].[ProductId]
				,[t].[IsDisabled] = [tvp].[IsDisabled]
				,[t].[RepUpdateTime] = CASE WHEN [tvp].[RepUpdateTime] > ISNULL([t].[RepUpdateTime],'') THEN [tvp].[RepUpdateTime] ELSE [t].[RepUpdateTime] END
		WHEN MATCHED AND [tvp].isDeleted = 1 THEN
			DELETE
		WHEN NOT MATCHED AND [tvp].[isDeleted] = 0 THEN
			INSERT ([custid]
				,[product]
				,[seq]
				,[ProductId]
				,[IsDisabled]
				,[RepUpdateTime])
			VALUES ([tvp].[custid]
				,[tvp].[product]
				,[tvp].[seq]
				,[tvp].[ProductId]
				,[tvp].[IsDisabled]
				,[tvp].[RepUpdateTime])
		OUTPUT $action, [deleted].[custid], [deleted].[product], [tvp].[RepUpdateTime]
	) AS __deleting([Action], [custid], [product], [RepUpdateTime])
	WHERE [Action] = 'DELETE'; --only capture deleted $action
		
END	
GO
GRANT EXECUTE ON [dbo].[DR_Repl_PutAcc_DWLList_xtest_Dist] TO [repl_ap]
GO