 /*
	Created: Johnson
	Date: 20150114
	Task: copy permission for NAPU3's users
	DB: DBPOLICY/BODB02
 */
 --step 1: Add more functions for NAPU3
USE [bodb02]
GO
 
INSERT INTO [dbo].[Acc_FunctionInfo]
           ([FuncName]
           ,[FuncNote]
           ,[FuncDesc]
           ,[FuncRender]
           ,[CreateDate]
           ,[ModifyDate]
           ,[DisplayOrder]
           ,[Creator]
           ,[ParentID]
           ,[Filenames]
           ,[System])
SELECT [FuncName]
           ,[FuncNote]
           ,[FuncDesc]
           ,[FuncRender]
           ,GETDATE()
           ,GETDATE()
           ,[DisplayOrder]
           ,[Creator]
           ,[ParentID]
           ,[Filenames]
           ,'NAPU3'
from [Acc_FunctionInfo]
where System = 'Accounting'
    AND [FuncName] IN ('[Customer]','[OtherCust]','[ViewInfo]','[CustomerStatement]','[UserControl]') 
GO
--update parentid for new functions on NAPU3
DECLARE @funcid INT
 
SELECT @funcid = FuncID
FROM Acc_FunctionInfo (NOLOCK)
WHERE FuncName = '[Customer]'
AND System =  'NAPU3'
 
--reset parentID for new functions on NAPU3
update Acc_FunctionInfo
SET ParentID = @funcid
where FuncName IN ('[OtherCust]','[ViewInfo]','[CustomerStatement]')
AND System = 'NAPU3' 
GO
-----------------------------------------------
--step2: Initial permissions on NAPu3 functions 
INSERT INTO [dbo].[Acc_MemberPolicy_1]
           ([CustID]
           ,[FuncID]
           ,[Policy]
           ,[CreateDate]
           ,[ModifyDate]
           ,[Creator])
select ac.custid,t.FuncID,0 as policy, GETDATE(),GETDATE(),NULL as creator
from acccustomer_1 ac WITH(NOLOCK)
    CROSS JOIN (SELECT FuncID from Acc_FunctionInfo with(NOLOCK) WHERE System = 'NAPU3') t
GO
 
INSERT INTO [dbo].[Acc_GroupPolicy_1]
           ([GroupID]
           ,[FuncID]
           ,[Policy]
           ,[CreateDate]
           ,[ModifyDate]
           ,[Creator])
select gp.GroupID,t.FuncID,0 as policy, GETDATE(),GETDATE(),NULL as creator
from [dbo].[Acc_GroupInfo_1] gp WITH(NOLOCK)
    CROSS JOIN (SELECT FuncID from Acc_FunctionInfo with(NOLOCK) WHERE System = 'NAPU3') t
GO
--------------------------------
--step 3:Grant permission for spicific accounts 
DECLARE @tmpCust TABLE (custid int)
 
INSERT INTO @tmpCust
SELECT custid
FROM Customer (NOLOCK)
where username IN ('starix24', 'starix14')
 
 
UPDATE mp
SET mp.Policy = 1
from Acc_MemberPolicy_1 mp WITH(UPDLOCK,ROWLOCK)
    inner join accCustomer_1 ac (NOLOCK) ON ac.custid = mp.CustID
    INNER join Acc_FunctionInfo fi ON mp.FuncID = fi.FuncID
WHERE fi.System = 'NAPU3'
    AND fi.[FuncName] IN ('[Customer]','[OtherCust]','[ViewInfo]','[CustomerStatement]','[UserControl]') 
    AND ac.custid IN (SELECT custid from @tmpCust)