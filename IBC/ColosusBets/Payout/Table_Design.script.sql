--DBTRANS\bodb02
USE bodb02
GO
CREATE TABLE dbo.PayoutTrans
(
	PayoutTransId		bigint NOT NULL
	,CustId				int NOT NULL
	,CreatedDate		smalldatetime NULL
	,WinAmount			money NOT NULL
	,PayCode			nvarchar(250)
	,StatusId			tinyint NULL
	,PayStatus			nvarchar(20) NULL
	,LastModifyDate		smalldatetime NULL
	,LastModifyBy		int	NULL
	,CONSTRAINT PK_PayoutTrans_PayoutTransId PRIMARY KEY CLUSTERED (PayoutTransId)
) ON [DATA]
GO
CREATE TABLE dbo.PayoutDetail
(
	PayoutTransId	bigint NOT NULL
	,CreatedDate	smalldatetime NULL
	,CreatedBy		int NOT NULL
	,StatusId		tinyint NULL
	,PayStatus		nvarchar(20) NULL
	,PayNote		nvarchar(1000) NULL
	,IP				varchar(50) NOT NULL
) ON [DATA]