/*<info serverAlias="DBAFF-Affiliate_Athena000"></info>*/
/*
	Created: 20211222@Percy
	DB: DBAFF-Affiliate_Athena000
	Task: Integrate Sports Lottery
*/

-- Affiliate_Aoncash
-- Affiliate_Athena000
-- Affiliate_ItcBet
-- Affiliate_MacauBet
-- Affiliate_Spondemo
insert into dbo.Product (ProductName, API_ProductID, Creator, CreatedDate, Description, EffectiveDate, IsEnabled)
values ('Sports Lottery', 63, 13, getdate(), 'Sports Lottery', '2022-02-01', 1)