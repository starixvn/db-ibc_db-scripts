/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G"></info>*/
/*
	Created: 20211018@Percy
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: Update data for payment account info
	
	use Affiliate_N88
	go
	use Affiliate_N8B
	go
	use Affiliate_N8G
	go
*/


declare @SiteId int
select  @SiteId = case DB_NAME()
					when 'Affiliate_N88' then 1
					when 'Affiliate_N8G' then 2
					else 3 end

update ad with (rowlock)
set ad.Player_CustId = c.CustId, ad.Player_Currency = case when c.IsTest = 1 then 20 else c.CurrencyId end
from dbo.AffDetail ad
	inner join bodb_N88.dbo.Customer c with (nolock) on ad.Player_UserName = c.UserName and c.SiteId = @SiteId
where ad.Player_CustId = 0 or ad.Player_Currency = 0