/*
	Created: 20190122@Kathy
	DB: DBTXN/bodb02
	Task: create non clustered index for zzzbettrans/zzzbettransm [Redmine:#90155]
*/
USE bodb02
GO

CREATE NONCLUSTERED INDEX IX_zzzbettrans_VoidingHistoryId ON zzzbettrans (VoidingHistoryId) WHERE VoidingHistoryId IS NOT NULL
CREATE NONCLUSTERED INDEX IX_zzzbettransm_VoidingHistoryId ON zzzbettransm (VoidingHistoryId) WHERE VoidingHistoryId IS NOT NULL
