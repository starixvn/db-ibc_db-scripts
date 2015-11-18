USE [bodb02]
GO

CREATE TABLE [dbo].[PayoutTrans](
	[PayoutTransId] [int] NOT NULL,
	[CustId] [int] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[RefNo] [bigint] NOT NULL,
	[ProductId] [smallint] NOT NULL,
	[VendorId] [int] NOT NULL,
	[TransDate] [datetime] NULL,
	[WinlostDate] [smalldatetime] NULL,
	[WinAmount] [money] NOT NULL,
	[PayoutCode] [nvarchar](250) NULL,
	[PayoutStatusId] [tinyint] NULL,
	[PayoutStatus] [nvarchar](20) NULL,
	[GameId] [smallint] NULL,
 CONSTRAINT [PK_PayoutTrans_PayoutTransId] PRIMARY KEY CLUSTERED 
(
	[PayoutTransId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

GRANT SELECT ON [dbo].[PayoutTrans] TO [bodbAdminNet]
GO

USE [bodb_CustomerLog]
GO

CREATE TABLE [dbo].[PayoutDetail](
	[PayoutTransId] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Creator] [int] NOT NULL,
	[PayoutStatusId] [tinyint] NULL,
	[PayoutStatus] [nvarchar](20) NULL,
	[PayoutNote] [nvarchar](1000) NULL,
	[IP] [varchar](50) NOT NULL
) ON [DATA]

GO

GRANT INSERT ON [dbo].[PayoutDetail] TO [bodbAdminNet]
GO
GRANT SELECT ON [dbo].[PayoutDetail] TO [bodbAdminNet]
GO