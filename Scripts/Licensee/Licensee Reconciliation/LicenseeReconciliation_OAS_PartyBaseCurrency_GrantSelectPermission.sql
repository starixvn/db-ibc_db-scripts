/*<info serverAlias="DBACC-bodb_Licensee"></info>*/
/*
	Created: 20210322@Percy
	DB: DBACC-bodb_Licensee
	Task: Grant select permission on OAS_PartyBaseCurrency to bodbAdminNet
*/
use bodb_Licensee
go

grant select on dbo.OAS_PartyBaseCurrency to bodbAdminNet as dbo
go