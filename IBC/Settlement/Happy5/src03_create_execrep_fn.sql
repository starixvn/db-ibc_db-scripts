/*
	Created: Vicky
	Task: create execrep fn
	DB: DBTXN/bodb02, DBACC/bodb02, DBAGE/bodb02, DBEXT/bodb02, DB042/bodb02
	Date: 20181114
	publication: DBTrans_Bet
*/
USE [bodb02]
GO

-------------------------------------------------------------SP NAP_Admin_Calculate_OtherSports
CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_OtherSports]
	@strTransIds				   VARCHAR(MAX)	= NULL
AS
BEGIN
	SELECT 1
END 
GO
