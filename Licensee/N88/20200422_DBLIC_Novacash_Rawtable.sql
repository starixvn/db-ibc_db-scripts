use bodb_3rdProduct
go

/*
	Created: 20200422@Percy
	DB: DBLIC.bodb_3rdProduct
	Task: New raw table for Novacash
*/

create table dbo.TpBetRecord
(
	TpId			int	not null,
	TransId			varchar(20)	not null,
	GameType		int	not null,
	CustId			varchar(45)	not null,
	UserName		varchar(30)	not null,
	CurrencyId		int	not null,
	SiteId			int	not null,
	TpUserName		varchar(50)	not null,
	TransTime		datetime not null,
	SettledTime		datetime not null,
	Stake			decimal(18,2) not null,
	WinlostAmount	decimal(18,2) not null,
	SettlementType	tinyint not null,
	TicketStatus	tinyint not null,
	OriginalState	varchar(10),
	TicketKey		bigint not null,
	CreateTime		datetime not null,
	IBCCustId		int,
	WinlostDate		smalldatetime,
	constraint pk_TpBetRecord primary key
	(
		TpId asc,
		TransId asc,
		GameType asc
	) on [3rdProduct_Data]
) on [3rdProduct_Data]
go


CREATE TABLE [dbo].[ServerInfo](
	[SiteId] [int] NOT NULL,
	[SiteName] [varchar](50) NULL,
	[LicenseeName] [varchar](50) NULL
) ON [PRIMARY]
GO

INSERT INTO dbo.ServerInfo (SiteId, SiteName, LicenseeName)
VALUES
	(1, 'Nova88', 'N88')
	,(2, 'Goal123', 'N8G')
	,(3, 'Bwing', 'N8B')