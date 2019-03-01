/*	Created by: Kathy
	Date 20181212
	Task: new table for settlement CN88 [Redmine:#109007]
	DB: publication DBTrans_Bet
		
*/      
USE [bodb02]
GO

CREATE TABLE [dbo].[CS_CustSuper](
	[CustId] [int] NOT NULL,
 CONSTRAINT [PK_CS_CustSuper] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO


