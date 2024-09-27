/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Created: 20240927@Kelvin
	DB: DBTRANS-bodb02
	Task: Deposit - Saba Reward - Support Odds Boost Voucher [RedmineID: #199292]
*/

USE bodb02
GO

update bettrans
set custid = 0
where winlostdate between '2024-09-23' and '2024-09-24'
	and bettype = 997
	and SiteDBGroupID = 0

GO
