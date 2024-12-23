/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created: 20241223@Lewis
	DB: DBPRO-bodb02
	Task: XML OddsFeed - RepInhouse LeagueSetting - Source [RedmineID: #215667]
*/

--dbpro

-- =============================
-- LeagueSetting
-- =============================


-- =============================
-- LeagueSetting_Del_InHouse
-- =============================
CREATE TABLE [dbo].[LeagueSetting_Del_InHouse](
	[Leagueid] [int] NOT NULL,
	[stamp] [datetime] NOT NULL
) ON [Event_table]
GO

ALTER TABLE dbo.LeagueSetting_Del_InHouse ADD CONSTRAINT DF_LeagueSetting_Del_InHouse_stamp DEFAULT (getdate()) FOR [stamp]
GO

CREATE CLUSTERED INDEX CIX_LeagueSetting_Del_InHouse ON LeagueSetting_Del_InHouse([stamp]) ON Event_index
GO
