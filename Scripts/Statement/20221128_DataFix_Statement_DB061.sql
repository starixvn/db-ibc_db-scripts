/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	RUN at KBT@DB061
	Created: Bobby@20221129
	Task: Correct Statement historical data
	Redmine: https://nexdev.net/issues/169560
*/
use [bodb_Report];
GO
-- UPDATE 3326 wrong rows
with result as (
	SELECT uat.[custid]
		,uat.[accdate]
		,uat.[totalamt]
		,uat.[transtype]
		,uat.[transdesc]
		,st.totalamt AS [totalamt_Old]
	FROM [dbo].[tmp_Statement_UAT] uat with(nolock)
	inner join dbo.Statement st with(nolock) on st.custid = uat.custid and st.accdate = uat.accdate and st.transtype = uat.transtype
	where uat.totalamt <> 0
		and uat.totalamt <> st.totalamt
)
--select count(1) from result
update st with(rowlock, updlock)
set st.totalamt = rs.totalamt
from dbo.Statement st
inner join result rs on rs.custid = st.custid and rs.accdate = st.accdate and rs.transtype = st.transtype

--- ADD 886 missed rows
INSERT INTO [dbo].[Statement]
           ([custid]
           ,[accdate]
           ,[totalamt]
           ,[transtype]
           ,[transdesc])
SELECT uat.[custid]
    ,uat.[accdate]
    ,uat.[totalamt]
    ,uat.[transtype]
    ,uat.[transdesc]
FROM [dbo].[tmp_Statement_UAT] uat with(nolock)
left join dbo.Statement st with(nolock) on st.custid = uat.custid and st.accdate = uat.accdate and st.transtype = uat.transtype
where uat.totalamt <> 0
	and st.custid is null