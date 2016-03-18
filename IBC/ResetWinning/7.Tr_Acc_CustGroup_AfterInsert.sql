USE bodb_Age
GO

ALTER TRIGGER Tr_Acc_CustGroup_AfterInsert ON Acc_CustGroup
AFTER INSERT
AS
 
/*  
	Created: 20160317@Sophia
	Task :  Auto insert setting Extra PT when insert a new super to a group
	DB: DBAGE/bodb_Age
	
	Revisions:     

*/
BEGIN 

	DECLARE @FromDate DATE, @ToDate DATE  
	SELECT @FromDate = GETDATE(), @ToDate ='9999-12-31'

	DECLARE @CustId INT, @SuperId INT , @GroupName VARCHAR(50)
	 
	SELECT @CustId = CustId, @GroupName = GroupName
	FROM INSERTED 

	IF EXISTS (	SELECT TOP 1 1 
				FROM Acc_CustGroup WITH (NOLOCK)
				WHERE GroupName = @GroupName AND IsPayout = 1)	 
	BEGIN 
		SELECT TOP 1 @SuperId = SuperId   
		FROM DBACC.bodb_Acc.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
		WHERE GroupName = @GroupName
			
		INSERT INTO DBACC.bodb_Acc.dbo.Acc_GroupExtraPTSetting (SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct, ExtraPT, FromDate, ToDate ) 
		SELECT @CustID AS SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct,ExtraPT, @FromDate AS FromDate, @ToDate AS ToDate  
		FROM DBACC.bodb_Acc.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
		WHERE GroupName = @GroupName AND SuperID = @SuperID
		
		IF @GroupName IN ('ACCTHAI2','ACCTHAI56','ACCTHAI99')
		BEGIN	
			INSERT INTO DBACC.bodb_Acc.dbo.Acc_GroupExtraPTSetting (SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct,ExtraPT, FromDate, ToDate )
			SELECT @CustID AS SuperId, GroupId, GroupName, ProductId, Sporttype, SubProduct,ExtraPT, @FromDate AS FromDate, @ToDate AS ToDate  
			FROM DBACC.bodb_Acc.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
			WHERE GroupName = 'BC' AND SuperID = @SuperID
		END
	END 
END 
 

  