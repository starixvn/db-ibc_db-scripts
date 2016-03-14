USE bodb_Age
GO

CREATE TRIGGER Tr_Acc_CustGroup_AfterInsert ON Acc_CustGroup
AFTER INSERT
AS

BEGIN 

DECLARE @FromDate DATE, @ToDate DATE  
SELECT @FromDate = GETDATE(), @ToDate ='9999-12-31'

DECLARE @CustId INT, @SuperId INT , @GroupName VARCHAR(50)
SELECT @CustId = 0  
 
SELECT @CustId = CustId, @GroupName = GroupName
FROM INSERTED
WHERE IsPayout = 1 

IF @CustId <> 0
BEGIN 
	SELECT TOP 1 @SuperId = SuperId   
	FROM DBACC.bodb_Acc.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
	WHERE GroupName = @GroupName
		
	SELECT @CustID AS SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, @FromDate AS FromDate, @ToDate AS ToDate  
	FROM DBACC.bodb_Acc.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
	WHERE GroupName = @GroupName AND SuperID = @SuperID
	
	IF @GroupName IN ('ACCTHAI2','ACCTHAI56','ACCTHAI99')
	BEGIN	
		SELECT @CustID AS SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, @FromDate AS FromDate, @ToDate AS ToDate  
		FROM DBACC.bodb_Acc.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
		WHERE GroupName = 'BC' AND SuperID = @SuperID
	END
END 
END 
 

  