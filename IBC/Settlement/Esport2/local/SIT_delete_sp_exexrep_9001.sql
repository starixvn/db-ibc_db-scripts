/*
	Created: Vicky
	Task: Remove unused SP
	DB: DBTXN/bodb02, DBACC/bodb02, DBAGE/bodb02, DBEXT/bodb02, DB042/bodb02
	Date: 20180912
	publication: DBTrans_ExecRep
*/
USE [bodb02]
GO

-------------------------run at DBTXN only--------------------------------------
DROP PROCEDURE [dbo].[NAP_Admin_Calculate_9001_UAT3]
GO
DROP PROCEDURE [dbo].[NAP_Admin_Calculate_Refund_9001_UAT3] 
GO
DROP PROCEDURE [dbo].[NAP_Admin_Calculate_Undo_9001_UAT3]
GO



------------------------run at all replicated servers and DBTXN-----------------
DROP PROCEDURE [dbo].[NAP_Admin_Calculate_9001]
GO
DROP PROCEDURE [dbo].[NAP_Admin_Calculate_Refund_9001] 
GO
DROP PROCEDURE [dbo].[NAP_Admin_Calculate_Undo_9001]
GO


