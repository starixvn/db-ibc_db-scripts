/*
	Created: Vicky
	Task: create execrep fn
	DB: DBTXN/bodb02, DBACC/bodb02, DBAGE/bodb02, DBEXT/bodb02, DB042/bodb02
	Date: 20180912
	publication: DBTrans_ExecRep
*/
USE [bodb02]
GO

-------------------------------------------------------------SP NAP_Admin_Calculate_TransID
CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_TransID]
    @transIds           VARCHAR(MAX)
AS
BEGIN
	SELECT 1
END 
GO
-------------------------------------------------------------SP NAP_Admin_Calculate_Refund_9001	
CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_Refund_9001]
	@transIds					VARCHAR(MAX)	 = NULL

AS
BEGIN
	SELECT 1
END 
GO

-------------------------------------------------------------SP NAP_Admin_Calculate_Undo_TransID
CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_Undo_TransID]
	@transIds      		VARCHAR(MAX)
AS
BEGIN
	SELECT 1
END 
GO