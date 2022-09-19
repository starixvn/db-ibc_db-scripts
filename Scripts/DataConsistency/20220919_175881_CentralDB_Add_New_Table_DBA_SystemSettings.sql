/*<info serverAlias="DBCONSISTENCY-bodb_Consistency" executers="" viewers="" isFunction="0"></info>*/
/*
	Created: 20220915@Sol
	Task: Data consistency - Add new settings
	DB: DBCONSISTENCY-bodb_Consistency

	Revisions: 
		- 20220919@Sol: Scale out DBTrans - Detect data consistency SiteDB and CentralDB 
						- Add new table settings - [Redmine:#175881]

*/

USE bodb_Consistency;

GO 

---create new table
CREATE TABLE [dbo].[DBA_SystemSettings](
	[VID] [int] IDENTITY(1,1) NOT NULL,
	[VName] [varchar](200) NULL,
	[VValue] [varchar](200) NULL,
	CONSTRAINT [PK_SystemSettings] PRIMARY KEY CLUSTERED 
	(
		[VID] ASC
	)
)

GO