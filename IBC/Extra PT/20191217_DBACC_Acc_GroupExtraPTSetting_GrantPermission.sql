/*
	Created: 20191217@Percy
	DB: DBACC.bodb02
	Task: Grant select on Acc_GroupExtraPTSetting to bodbDownlineNet & bodbDownlineNetView due to get data UplineId
*/
GRANT SELECT ON	Acc_GroupExtraPTSetting	TO bodbDownlineNet AS dbo
GO
GRANT SELECT ON	Acc_GroupExtraPTSetting	TO bodbDownlineNetView AS dbo
GO
