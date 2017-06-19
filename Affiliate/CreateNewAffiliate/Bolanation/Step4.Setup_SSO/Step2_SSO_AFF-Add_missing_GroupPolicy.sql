/*Remmeber to run on Affiliate DB*/
use Affiliate_Bolanation
go

declare @LicenseeID int

select @LicenseeID = SValue
from SystemSettings (nolock)
where SName = 'LicenseeID'

--insert missing groups to bodb_Licensee.dbo.Aff_GroupInfo

insert into DBLIC.bodb_Licensee.dbo.Aff_GroupInfo (LicenseeID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, Creator)
select @LicenseeID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, 1797 
from dbo.AffGroupInfo with (nolock)
where GroupName not in (select GroupName from DBLIC.bodb_Licensee.dbo.Aff_GroupInfo with (nolock)
						where LicenseeID = @LicenseeID)


--insert missing group permission to bodb_License.dbo.Aff_GroupPolicy
insert into DBLIC.bodb_Licensee.dbo.Aff_GroupPolicy (GroupID, FunctionID, Policy, CreateDate, ModifyDate, Creator)
select l_gi.GroupID, l_fi.FunctionID, a_gp.Policy, a_gp.CreateDate, a_gp.ModifyDate, 1797
from dbo.AffGroupPolicy a_gp with (nolock) 
	 inner join dbo.AffFunctionInfo a_fi with (nolock) on a_gp.FuncID = a_fi.FuncID
	 inner join dbo.AffGroupInfo a_gi with (nolock) on a_gp.GroupID = a_gi.GroupID 
	 inner join DBLIC.bodb_Licensee.dbo.Aff_FunctionInfo l_fi with (nolock) on a_fi.FuncName = l_fi.FunctionName
	 inner join DBLIC.bodb_Licensee.dbo.Aff_GroupInfo l_gi with (nolock) on l_gi.GroupName = a_gi.GroupName AND l_gi.LicenseeID = @LicenseeID
	 left join DBLIC.bodb_Licensee.dbo.Aff_GroupPolicy l_gp with (nolock) on l_gi.GroupID = l_gp.GroupID
where a_gp.GroupID not in (select GroupID from AffGroupInfo with (nolock) where GroupName IN ('None','Aff_IT_Dept','Administrator'))
	 and l_gp.GroupID is null



