/*
	Created by: Helen
	Date: 20150904
	Task: commission setting for MO [Redmine #41470]
	DB: DBCust.CustDB

*/ 

ALTER TABLE [dbo].[CustSuper] ADD IsMyanmarOdds BIT CONSTRAINT DF_CustSuper_IsMyanmarOdds DEFAULT(0) NULL