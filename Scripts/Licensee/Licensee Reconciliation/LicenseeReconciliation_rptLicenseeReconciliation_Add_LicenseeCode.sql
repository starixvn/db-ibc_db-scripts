/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210322@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: LA - Licensee Reconciliation - Add new LicenseeCode column to rptLicenseeReconciliation
*/
use bodb_LicenseeReport
go

-- add column
alter table dbo.rptLicenseeReconciliation
	add LicenseeCode varchar (50)
go

-- initialize data
-- 6483 rows
update r with (rowlock)
set r.LicenseeCode = isnull(p.LicenseeCode, '')
from bodb_LicenseeReport.dbo.rptLicenseeReconciliation r
	left join bodb_Licensee.dbo.OAS_PartyBaseCurrency p with (nolock)
		on r.PartyId = p.PartyId
			and r.AccDate between dateadd(month, datediff(month, 0, p.FromDate), 0) and p.ToDate
go