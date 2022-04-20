/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20220420@Malcolm
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: Add new table

*/
CREATE TABLE [dbo].[rptAffCommissionDetail](
	[MonthDate] [smalldatetime] NOT NULL,
	[AffId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Deposit] [money] NULL,
	[Withdrawal] [money] NULL,
	[Bonus] [money] NULL,
	[Adjustment] [money] NULL,
	[Turnover] [money] NULL,
	[Winloss] [money] NULL,
	[GrossWinloss] [money] NULL,
	[NetWinloss] [money] NULL,
	[QMTurnover] [money] NULL,
	[ActivePlayer] [int] NULL,
	[QualifiedMember] [int] NULL,
	[CommissionRate] [decimal](9, 8) NULL,
	[Rebate] [money] NULL,
	[Revenue] [money] NULL,
	[P2PFee] [money] NULL,
	[PlatFormFee] [money] NULL,
	[OperationalFee] [money] NULL,
	[DepositFee] [money] NULL,
	[WithdrawalFee] [money] NULL,
	[GroupProductId] [tinyint] NOT NULL,
 CONSTRAINT [PK_rptAffCommissionDetail] PRIMARY KEY CLUSTERED 
(
	[MonthDate] ASC,
	[AffId] ASC,
	[GroupId] ASC,
	[ProductId] ASC,
	[GroupProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [ReportData]
) ON [ReportData]
GO
