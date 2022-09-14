/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20220912@Evan
	DB: DBCUST-CustDB
	Task : Deposit - AG Group - CandyA18 - Support crypto
	https://nexdev.net/issues/177481
*/
USE [CustDB]

GO

CREATE TABLE [dbo].[ExchangeDaily_Crypto](
        [ExchangeDate] [smalldatetime] NOT NULL,
        [ExchangeId] [int] NOT NULL,
        [USDT] [float] NULL
 CONSTRAINT [PK_ExchangeDaily_Crypto] PRIMARY KEY CLUSTERED 
(
        [ExchangeDate] ASC,
        [ExchangeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO


