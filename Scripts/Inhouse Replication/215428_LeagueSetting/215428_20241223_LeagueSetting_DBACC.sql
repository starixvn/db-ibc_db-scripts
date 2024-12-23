/*<info serverAlias="DBACC-bodb02,DBBOF-bodb02"></info>*/
/*
	Created: 20241223@Lewis
	DB: DBACC-bodb02,DBBOF-bodb02
	Task: XML OddsFeed - RepInhouse LeagueSetting - Target [RedmineID: #215667]
*/

--06x + 054/055
USE [bodb02]
GO

ALTER TABLE [dbo].[LeagueSetting]
ADD [stamp] [datetime] NOT NULL

ALTER TABLE [dbo].[LeagueSetting] ADD  CONSTRAINT [DF_LeagueSetting_stamp]  DEFAULT (getdate()) FOR [stamp]
GO
