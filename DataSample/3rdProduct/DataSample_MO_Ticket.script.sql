--RUN on DB206 & DB230
USE bodb02
GO

DECLARE @status VARCHAR(10)
	, @custid	INT

-- bettrans	
SELECT @status 	= 'RUNNING'
	,@custid 	= 1176092

EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 301
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 302
	,@status  = @status


EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 303
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 304
	,@status  = @status

SET @status = 'WON'


EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 301
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 302
	,@status  = @status


EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 303
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 304
	,@status  = @status


SET @status = 'LOSE'
	
EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 301
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 302
	,@status  = @status


EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 303
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket_Ins]
	@CustID  = @custid
	,@Bettype = 304
	,@status  = @status
	
-- bettrans14
SET @status = 'WON'


EXEC [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID  = @custid
	,@Bettype = 301
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID  = @custid
	,@Bettype = 302
	,@status  = @status


EXEC [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID  = @custid
	,@Bettype = 303
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID  = @custid
	,@Bettype = 304
	,@status  = @status


SET @status = 'LOSE'
	
EXEC [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID  = @custid
	,@Bettype = 301
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID  = @custid
	,@Bettype = 302
	,@status  = @status


EXEC [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID  = @custid
	,@Bettype = 303
	,@status  = @status

EXEC [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID  = @custid
	,@Bettype = 304
	,@status  = @status	