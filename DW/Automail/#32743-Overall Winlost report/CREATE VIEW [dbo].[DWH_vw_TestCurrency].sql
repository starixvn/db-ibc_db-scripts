USE [bodb_dwrs]
GO

/****** Object:  View [dbo].[DWH_vw_TestCurrency]    Script Date: 8/13/2015 10:39:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[DWH_vw_TestCurrency]
AS
/*
Created: 20150722@Tom.Vo: 
DB: [bodb_dwrs]
Original: 
Task: Get List Test Currency

Revisions:

Param's Explanation:

Execute Example:
	SELECT * FROM [dbo].[DWH_vw_TestCurrency]
	
*/	 
	SELECT tbl.exchangeid currencyid
		,tbl.currency
		,tbl.actualrate
	FROM bodb02.dbo.Exchange tbl WITH (NOLOCK)
	WHERE actualrate < 2e-50
 


