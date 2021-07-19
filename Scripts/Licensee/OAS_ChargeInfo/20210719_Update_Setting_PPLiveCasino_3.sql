/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210719@Percy
	DB: DBCUST-bodb_Licensee
	Task: Update date range for PP Live Casino
		https://nexdev.net/issues/158415
*/
use bodb_Licensee
go

update dbo.OAS_ChargeInfo with (rowlock)
set FromDate = case when FromDate = '2021-08-01' then '2021-09-01' else FromDate end
	,ToDate = case when ToDate = '2021-07-31' then '2021-08-31' else ToDate end
where ProductId = 65 -- PP Live Casino
	and ToParty = 565 -- Pay to Suppiler (3rd)