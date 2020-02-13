/*
	Created: 20200213@Max
	Task: Abnormal Void Bets Automation [Redmine: #128359]
	DB: DBTRANS/BODB02
*/
USE bodb02
GO

CREATE PROCEDURE [dbo].[TicketVoiding_ReCal_Single_Update]
(
	@TransIds			VARCHAR(MAX)
	,@UserId			INT
	,@IP				VARCHAR(50)  
	,@ErrCode			INT				= 0		OUTPUT
	,@ErrMsg			VARCHAR(1000)	= ''	OUTPUT
)
AS
BEGIN
	RETURN;
END
