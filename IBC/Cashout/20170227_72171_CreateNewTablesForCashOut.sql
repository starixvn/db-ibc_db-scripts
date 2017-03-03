  /*
	Created: 20170227Winnie
	Task : Create table for CashOut
	DB: DBCust/CustDB.	Add TradeCust to the Publication CustDB_Customer_Info
*/


CREATE TABLE [dbo].[TradeCust](
	[custid] [int] NOT NULL,
	VendorID SMALLINT NOT NULL
 CONSTRAINT [PK_TradeCust] PRIMARY KEY CLUSTERED 
(
	[custid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [Dep_CustSetting3rd_table]
) ON [Dep_CustSetting3rd_table]

GO


CREATE TABLE [dbo].[TradeComm](
	[AgentID] [int] NOT NULL,
	[IsBA] [bit] NOT NULL,
	[TradeComm] [decimal](9, 8) NULL,
	[Licenseecomm] [decimal](9, 8) NULL,
	[HouseDeductionRate] [decimal](9, 8) NULL,
	[HousePT] [smallmoney] NULL,
	VendorID SMALLINT NOT NULL
 CONSTRAINT [PK_Tradecomm] PRIMARY KEY CLUSTERED 
(
	[AgentID] ASC,
	[IsBA] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustSetting3rd_table]
) ON [Dep_CustSetting3rd_table]

GO
