/*
	- Created@Bobby: 20200214
	- Task: New Forecast - Soccer OST version - [Redmine:121898]
*/
use bodb_ost
GO
--- Synonyms
GRANT SELECT ON dbo.match to [bodbDownlineNet]
GRANT SELECT ON dbo.match to [bodbDownlineNetView]

GRANT SELECT ON dbo.odds to [bodbDownlineNet]
GRANT SELECT ON dbo.odds to [bodbDownlineNetView]

use bodb02
GO
--- Tables
GRANT SELECT ON dbo.custinfo to [bodbDownlineNet]
GRANT SELECT ON dbo.custinfo to [bodbDownlineNetView]

GRANT SELECT ON dbo.match to [bodbDownlineNet]
GRANT SELECT ON dbo.match to [bodbDownlineNetView]

GRANT SELECT ON dbo.odds to [bodbDownlineNet]
GRANT SELECT ON dbo.odds to [bodbDownlineNetView]