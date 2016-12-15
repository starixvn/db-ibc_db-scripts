--select * from bodb_CustomerLog.dbo.LogAction_Lic
--delete bodb_CustomerLog.dbo.LogAction_Lic where spname in ('LA_PayerDel','LA_NonOfficialPayerIns')
/*
	Created: Bruce
	Task:	 #65260_InvoiceSetupFees
*/
use bodb_CustomerLog
go

-- edit LA_PayerModify log items
update dbo.LogAction_Lic set items = (
'<root>
  <xml path="r/z" />
  <row item="PayerID" alias="pid" />
  <row item="PartyName" alias="pn" />
  <row item="StatusId" alias="s" />
  <row item="isDeposit" alias="isd" />
  <row item="BrandName" alias="bn" />
  <row item="CompanyName" alias="cn" />
  <row item="AttnName" alias="an" />
  <row item="Description" alias="des" />
  <row item="Address1" alias="ad1" />
  <row item="Address2" alias="ad2" />
  <row item="BaseCurrencyId" alias="bc" />
</root>')
where SPName = 'LA_PayerModify'

-- get action id
declare @actionid int = (select max(actionid) from bodb_CustomerLog.dbo.LogAction_Lic) + 1

insert into bodb_CustomerLog.dbo.LogAction_Lic (actionid,ActionTypeId, SPName,ActionName,items,IsInternal)
values(
	@actionid,
	0,
	'LA_NonOfficialPayerIns',
	'',
'<root>
  <xml path="r/z" />
  <row item="PayerID" alias="pid" />
  <row item="PartyName" alias="pn" />
  <row item="StatusId" alias="s" />
  <row item="isDeposit" alias="isd" />
  <row item="BrandName" alias="bn" />
  <row item="CompanyName" alias="cn" />
  <row item="AttnName" alias="an" />
  <row item="Description" alias="des" />
  <row item="Address1" alias="ad1" />
  <row item="Address2" alias="ad2" />
  <row item="BaseCurrencyId" alias="bc" />
</root>',
	0)

set @actionid = @actionid + 1

insert into bodb_CustomerLog.dbo.LogAction_Lic (actionid,ActionTypeId, SPName,ActionName,items,IsInternal)
values(
	@actionid,
	0,
	'LA_PayerDel',
	'',
'<root>
  <xml path="r/z" />
  <row item="PayerID" alias="pid" />
  <row item="PartyName" alias="pn" />
  <row item="StatusId" alias="s" />
  <row item="isDeposit" alias="isd" />
  <row item="BrandName" alias="bn" />
  <row item="CompanyName" alias="cn" />
  <row item="AttnName" alias="an" />
  <row item="Description" alias="des" />
  <row item="Address1" alias="ad1" />
  <row item="Address2" alias="ad2" />
  <row item="BaseCurrencyId" alias="bc" />
</root>',
	0)

use bodb_licensee
go

if not exists(select 1 from LA_InvoiceType where InvTypeId=7)
begin
	set identity_insert LA_InvoiceType on
	insert into  LA_InvoiceType(InvTypeId, InvTypeName) values(7,'Setup Fees')
	set identity_insert LA_InvoiceType off
end

if not exists(select 1 from LA_InvoiceTemplate where InvTemplateName='Setup-Fees')
begin
	insert into  LA_InvoiceTemplate(InvTemplateName, TemplatePath) values('Setup-Fees','')
end
