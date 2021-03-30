/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
Create: 20210330@Danny
Task: Grant permission on transfer_bk [Redmine: #146038]
DB: DBARC-bodb_Archive

*/

use [bodb_Archive]
GO
GRANT SELECT ON [dbo].[transfer_bk] TO [bodbDownlineNet]
GO
GRANT SELECT ON [dbo].[transfer_bk] TO [bodbDownlineNetView]
GO