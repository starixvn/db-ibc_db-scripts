use bodb_report
GO 

/*
Create : 20190507@Sophia
Task: Total Balance Tables for Credit Collection Report [redmine:109293]
DB: DBRPT.bodb_report

*/
  
 ---New table

CREATE TABLE [dbo].[rptTotalBalance_Active](
	[CustID] [int] NOT NULL,
	[WinlostDate] [date] NOT NULL,
	[OpenningBalance] [money] NULL,
	[OpenningTotalBalance] [money] NULL,
 CONSTRAINT [CIX_rptTotalBalance_Active] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[WinlostDate] ASC	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rptStatement_New]
) ON [rptStatement_New]
GO


---- Add new column 

ALTER TABLE rptStatement 
ADD OpenningTotalBalance MONEY


ALTER TABLE rptStatement_OLD
ADD OpenningTotalBalance MONEY 