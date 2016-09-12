/*  
	Created: 20160907@Harper		
	Task:	#62820_LA - Implement Allbet - Insert AllBet Party and ChargeInfo information of this party
	DB:		DBLIC.bodb_licensee	 				
*/

-- Insert Party
INSERT INTO dbo.OAS_Party
        ( PartyName, Description, PartyType, OldRefID )
VALUES  ( 'AllBet', 'AllBet', 3, NULL )
GO

-- Insert Charge Info
DECLARE @ProductID INT, -- 21
		@AllbetID INT

SELECT @ProductID = ProductID FROM dbo.Product3rd (NOLOCK) WHERE ProductName = 'Allbet'
SELECT @AllbetID = PartyID FROM dbo.OAS_Party (NOLOCK) WHERE PartyName = 'AllBet'

INSERT INTO dbo.OAS_ChargeInfo
        ( ProductID ,
          FromParty ,
          ToParty ,
          ParentChargeID ,
          Rate ,
          ChargeType ,
          FromDate ,
          ToDate ,
          MinAmount ,
          MaxAmount ,
          Remark ,
          BaseCurrencyId ,
          FirstOfBilling ,
          BasisOfBilling
        )
VALUES  ( @ProductID , 1 , @AllbetID , 0 , 0.05 , 9 , '20160930' , '20500101' , NULL , NULL , 
          N'Credit group charge rate' , NULL , NULL , NULL ),
		( @ProductID , 1 , @AllbetID , 0 , 0.04 , 10 , '20160930' , '20500101' , NULL , NULL , 
          N'Deposit group charge rate' , NULL , NULL , NULL ),
		( @ProductID , 1 , @AllbetID , 0 , 0.01 , 11 , '20160930' , '20500101' , NULL , NULL , 
          N'Rebate Commission charge rate' , NULL , NULL , NULL )