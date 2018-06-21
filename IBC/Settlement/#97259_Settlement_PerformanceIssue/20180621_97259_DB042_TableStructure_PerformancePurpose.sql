/*
	Created: 20180621@Helen
	Task: Settlement improvement
	DB: DB042.bodb02
*/
USE bodb02
GO
CREATE TABLE [dbo].[Tickets_settled_setting](
	[sKey] varchar(30) NOT NULL,
	[sValue] [bigint] NOT NULL

) ON [PRIMARY]
GO

CREATE UNIQUE CLUSTERED INDEX [CIX_Tickets_settled_setting] ON [dbo].[Tickets_settled_setting]
(
	[sKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

INSERT INTO dbo.Tickets_settled_setting([sKey], sValue) values('bettrans', 0)

