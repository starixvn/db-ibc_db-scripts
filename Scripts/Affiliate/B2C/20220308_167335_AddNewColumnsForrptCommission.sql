/*<info serverAlias="DBAFFN88-Affiliate_N88"></info>*/
/*
	Created: 20220308@Malcolm
	DB: DBAFFN88-Affiliate_N88
	Task: add new columns
*/

ALTER TABLE dbo.rptAffCommission
DROP CONSTRAINT PK_rptAffCommission
GO

ALTER TABLE dbo.rptAffCommission
ADD GroupProductId TINYINT 
GO

UPDATE dbo.rptAffCommission
SET GroupProductId = 0
GO

ALTER TABLE dbo.rptAffCommission
ALTER COLUMN GroupProductId TINYINT NOT NULL 
GO


ALTER TABLE dbo.rptAffCommission
ADD CONSTRAINT PK_rptAffCommission PRIMARY KEY (MonthDate, AffId, GroupId, ProductId, GroupProductId)
GO

