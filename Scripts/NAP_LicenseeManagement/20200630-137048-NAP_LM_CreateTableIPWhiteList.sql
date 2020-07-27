/*
	Created: 20200630@Mark
	Task: Create Table IPWhiteList
	DB: DBCUST.bodb_Licensee
	 
	Revisions:
		- 20200630@Mark: Create Table IPWhiteList [RedmineID: #137048]
*/
CREATE TABLE [dbo].[IPWhiteList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IPValue] [varchar](40) NOT NULL,
	[ModifiedUser] [varchar](30) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Remark] [nvarchar](80) NULL,
	CONSTRAINT [PK_IPWhiteList] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [licensee_table]
) ON [licensee_table]
GO

SET ANSI_PADDING OFF
GO

/*<info serverAlias="DBCUST-bodb_licensee"></info>*/
