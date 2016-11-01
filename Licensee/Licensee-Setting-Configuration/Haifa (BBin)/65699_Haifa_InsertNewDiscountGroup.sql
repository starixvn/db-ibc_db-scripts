USE bodb_licensee
GO

/*
	Created:	Harper@20161020
	Task:		#61220: Insert discount information for HAIFA
	DB:			DBLIC.bodb_licensee

	Revisions:

	Param's Explanation:
				Currency = 13 (CNY)		
				DiscountGroupType = 3 (Discount based on Licensee WL)
*/

DECLARE @PartyID INT
SELECT @PartyID = PartyID FROM dbo.OAS_Party (NOLOCK) WHERE PartyName LIKE '%HAIFA%'

IF EXISTS (SELECT 1 FROM dbo.LA_DiscountGroupAssignment WHERE PartyID = @PartyID)
BEGIN
	UPDATE dgh
	SET ToDate = '20160831'
	FROM dbo.LA_DiscountGroupHeader dgh
	WHERE DiscountGroupType = 1 
		AND EXISTS (SELECT 1 
					FROM dbo.LA_DiscountGroupAssignment dga (NOLOCK) 
					WHERE dga.DiscountGroupId = dgh.DiscountGroupId AND dga.PartyID = @PartyID)
		AND EXISTS (SELECT 1
					FROM dbo.LA_DiscountGroupProduct dgp (NOLOCK)
					WHERE dgp.DiscountGroupId = dgh.DiscountGroupId AND dgp.ProductId IN (0, 5))

	-- Insert new discount header
	INSERT INTO dbo.LA_DiscountGroupHeader(DiscountGroupName, DiscountGroupType, CurrencyId, FromDate, ToDate, Priority)
	VALUES  ('Discount HAIFA #3-SB: Sep-16 to current' , 3 , 13 , '20160901' , '20500101' , 1), -- If DistGroupType = 1 then 1
			('Discount HAIFA #3-VS: Sep-16 to current' , 3 , 13 , '20160901' , '20500101' , 1)

	-- Insert new discount assginment
	DECLARE @DiscountGroupSBID INT,
			@DiscountGroupVSID INT

	SELECT @DiscountGroupSBID = DiscountGroupId FROM dbo.LA_DiscountGroupHeader WHERE DiscountGroupName = 'Discount HAIFA #3-SB: Sep-16 to current'
	SELECT @DiscountGroupVSID = DiscountGroupId FROM dbo.LA_DiscountGroupHeader WHERE DiscountGroupName = 'Discount HAIFA #3-VS: Sep-16 to current'
	
	INSERT INTO dbo.LA_DiscountGroupAssignment( DiscountGroupId, PartyID )
	VALUES  (@DiscountGroupSBID, @PartyID),
			(@DiscountGroupVSID, @PartyID)

	-- Insert new discount Detail
	INSERT INTO dbo.LA_DiscountGroupDetail( DiscountGroupId, FromAmount, ToAmount, Rate)
	VALUES  (@DiscountGroupSBID , NULL , NULL , 0.055),
			( @DiscountGroupVSID , NULL , NULL , 0.025)

	-- Insert new discount Product
	INSERT INTO dbo.LA_DiscountGroupProduct
	        ( DiscountGroupId, ProductId )
	VALUES  (@DiscountGroupSBID, 0), -- SB
			(@DiscountGroupVSID, 5)  -- VS
END
