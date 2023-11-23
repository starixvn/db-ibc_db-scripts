/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
/*
	Created: 20231010@Lewis
	DB: DBODDSFEED-bodb_OddsFeed
	Task: Insert into dbo.LogType TypeName = 'Licensee'
*/
USE [bodb_oddsfeed]
GO

INSERT INTO [dbo].[LogType]
           ([TypeName]
           ,[Description])
     VALUES
           (
			'Licensee'
           ,'Write log for deactive automatically by OIC'
		   )
GO







