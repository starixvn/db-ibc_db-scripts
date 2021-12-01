/*<info serverAlias="DBTXN-bodb02,DBACC-bodb02,DBAGE-bodb02,DBBOF-bodb02,DBBAH-bodb02,DBBAL-bodb02" step="2"></info>*/

USE bodb02
GO
 
CREATE TABLE dbo.Transfer(
	TransId BIGINT IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	CustId INT NOT NULL,
	TransDate DATETIME NOT NULL CONSTRAINT DF_Transfer_TransDate DEFAULT (GETDATE()),
	WinlostDate SMALLDATETIME NULL CONSTRAINT DF_Transfer_Winlostdate  DEFAULT (GETDATE()),
	Bettype SMALLINT NULL,
	Stake	MONEY NOT NULL CONSTRAINT DF_Transfer_stake  DEFAULT ((0)),
	Actual_Stake MONEY NULL CONSTRAINT DF_Transfer_Actual_Stake  DEFAULT ((0)),
	Winlost MONEY NULL CONSTRAINT DF_Transfer_Winlost  DEFAULT ((0)),
	AWinlost MONEY NULL CONSTRAINT DF_Transfer_AWinlost  DEFAULT ((0)),
	MWinlost MONEY NULL CONSTRAINT DF_Transfer_MWinlost  DEFAULT ((0)),
	SWinlost MONEY NULL CONSTRAINT DF_Transfer_SWinlost  DEFAULT ((0)),
	PlayerComm MONEY NULL CONSTRAINT DF_Transfer_PlayerComm  DEFAULT ((0)),
	Comm MONEY NULL CONSTRAINT DF_Transfer_Comm  DEFAULT ((0)),
	AComm MONEY NULL CONSTRAINT DF_Transfer_AComm  DEFAULT ((0)),
	SComm MONEY NULL CONSTRAINT DF_Transfer_SComm  DEFAULT ((0)),	
	StatusId TINYINT NULL,	
	RefNo BIGINT NOT NULL,
	TransDesc NVARCHAR(1000) NULL,
	Recommend	INT NOT NULL,
	MRecommend	INT NOT NULL,
	SRecommend	INT NOT NULL,
	Username	VARCHAR(30) NULL,
	Currency	TINYINT NULL,	
	CurrencyName NVARCHAR(50) NULL,
	ActualRate	FLOAT NULL,
	Creator INT NOT NULL CONSTRAINT DF_Transfer_Creator  DEFAULT ((0)),
	Balance	MONEY NULL,
	IP VARCHAR (45) NULL,
	CheckTime	DATETIME NULL,
	SerialNo VARCHAR(50) NULL CONSTRAINT DF_Transfer_SerialNo DEFAULT ((0)),
	RepUpdateTime	DATETIME2(7) NULL CONSTRAINT DF_Transfer_RepUpdateTime DEFAULT (SYSDATETIME()),
	CONSTRAINT PK_Transfer PRIMARY KEY CLUSTERED 
	(
		TransID ASC
	) ON Transfer_Index
) ON Transfer_Table

GO
 
CREATE TABLE dbo.TransferInfo(
	TransId BIGINT NOT NULL,
	APositiontaking	SMALLMONEY NULL CONSTRAINT DF_TransferInfo_APositiontaking DEFAULT ((0)),
	MPositiontaking	SMALLMONEY NULL CONSTRAINT DF_TransferInfo_MPositiontaking DEFAULT ((0)),
	SPositiontaking	SMALLMONEY NULL CONSTRAINT DF_TransferInfo_SPositiontaking DEFAULT ((0)),
	EPositiontaking	SMALLMONEY NULL CONSTRAINT DF_TransferInfo_EPositiontaking DEFAULT ((0)),
	PlayerDiscount DECIMAL(9,8) NULL CONSTRAINT DF_TransferInfo_PlayerDiscount DEFAULT ((0)),
	Discount DECIMAL(9,8) NULL CONSTRAINT DF_TransferInfo_Discount DEFAULT ((0)),
	ADiscount DECIMAL(9,8) NULL CONSTRAINT DF_TransferInfo_ADiscount DEFAULT ((0)),
	SDiscount DECIMAL(9,8) NULL CONSTRAINT DF_TransferInfo_SDiscount DEFAULT ((0)),
	WalletType TINYINT NULL,
	BonusID	INT NULL,
	Amount MONEY NULL CONSTRAINT DF_TransferInfo_Amount DEFAULT ((0)),
	CheckerId INT NULL,
	CheckerName	VARCHAR(30) NULL, 
	IsCollection BIT NULL CONSTRAINT DF_TransferInfo_IsCollection DEFAULT ((0)), 
	IsDel BIT NULL CONSTRAINT DF_TransferInfo_IsDel DEFAULT ((0)),
	RepUpdateTime DATETIME2(7) NULL CONSTRAINT DF_TransferInfo_RepUpdateTime DEFAULT (SYSDATETIME()),
	CONSTRAINT PK_TransferInfo PRIMARY KEY CLUSTERED 
	(
		TransID ASC
	) ON Transfer_Index
) ON Transfer_Table

GO