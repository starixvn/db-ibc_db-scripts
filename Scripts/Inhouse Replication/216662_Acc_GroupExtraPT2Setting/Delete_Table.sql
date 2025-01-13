/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: 
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_GroupExtraPT2Setting_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[Acc_GroupExtraPT2Setting_Del_InHouse]
	(
		ID [INT] NOT NULL
		) ON [DATA]

	ALTER TABLE [dbo].[Acc_GroupExtraPT2Setting_Del_InHouse] ADD [RepUpdateTime] DATETIME2(7) CONSTRAINT [DF_Acc_GroupExtraPT2Setting_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME())

	CREATE CLUSTERED INDEX [CIX_Acc_GroupExtraPT2Setting_Del_InHouse_RepUpdateTime] ON [dbo].[Acc_GroupExtraPT2Setting_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_GroupExtraPT2Setting_Del_InHouse exists!!!'
END
GO
/***************************************************************************/




