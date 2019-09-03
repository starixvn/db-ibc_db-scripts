/*
	Created: 20190903@Helen
	Task: Add SP excrep for the feature Recover Bet14
	DB: DBTRANS/bodb02 and all replcated of Pub DBTrans_ExecRep
	
*/
USE bodb02
GO
CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_Bet14] 
AS
/*
	Created by: 20190715@Helen
	Task: Settlement  
	DB: DBTRANS/BODB02
	
	Revisions:
		- 20190715@Helen: Recover/Void tickets in Bet 14 - [Redmine:115377]
		
	Param's Explanation:  
					
*/
BEGIN
	
	SET NOCOUNT ON
END
GO

CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_SubParlay14] 
AS
/*
	Created by: 20190715@Helen
	Task: Settlement  
	DB: DBTRANS/BODB02
	
	Revisions:
		- 20190715@Helen: Recover/Void tickets in Bet 14 - [Redmine:115377]
		
	Param's Explanation:  
					
*/
BEGIN
	
	SET NOCOUNT ON
END
GO

CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_MainParlay14] 
AS
/*
	Created by: 20190715@Helen
	Task: Settlement  
	DB: DBTRANS/BODB02
	
	Revisions:
		- 20190715@Helen: Recover/Void tickets in Bet 14 - [Redmine:115377]
		
	Param's Explanation:  
					
*/
BEGIN
	
	SET NOCOUNT ON
END
GO

CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_MP_Bet14]
AS
/*
	Created by: 20190715@Helen
	Task: Settlement  
	DB: DBTRANS/BODB02
	
	Revisions:
		- 20190715@Helen: Recover/Void tickets in Bet 14 - [Redmine:115377]
		
	Param's Explanation:  
					
*/
BEGIN
	
	SET NOCOUNT ON
END
GO


CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_MP_Bet14_PreCal_29]
AS
/*
	Created by: 20190715@Helen
	Task: Settlement  
	DB: DBTRANS/BODB02
	
	Revisions:
		- 20190715@Helen: Recover/Void tickets in Bet 14 - [Redmine:115377]
		
	Param's Explanation:  
					
*/
BEGIN
	
	SET NOCOUNT ON
END
GO


CREATE PROCEDURE [dbo].[NAP_Admin_Calculate_MP_Bet14_29]
AS
/*
	Created by: 20190715@Helen
	Task: Settlement  
	DB: DBTRANS/BODB02
	
	Revisions:
		- 20190715@Helen: Recover/Void tickets in Bet 14 - [Redmine:115377]
		
	Param's Explanation:  
					
*/
BEGIN
	
	SET NOCOUNT ON
END
GO
	
CREATE PROCEDURE [dbo].[TicketVoiding_Admin_Voiding14TransId] 
AS
/*
	Created by: 20190715@Helen
	Task: Settlement  
	DB: DBTRANS/BODB02
	
	Revisions:
		- 20190715@Helen: Recover/Void tickets in Bet 14 - [Redmine:115377]
		
	Param's Explanation:  
					
*/
BEGIN
	
	SET NOCOUNT ON
END
GO	

CREATE FUNCTION [dbo].[f_Set_OddsTypeBettypes] ()
RETURNS TABLE
WITH SCHEMABINDING
AS

/*
    Created: 20190715@Helen
    Task:  Recover/Void tickets in Bet14
    DB: DBTXN/bodb02
    
    Revisions:
		- 20190715@Helen: Recover/Void tickets in Bet 14 [Redmine:115377]
	
    Parameters Explanation:    
		- oddsType
			+ 1: Decimal Odds
*/

RETURN (
    
	SELECT	
			CONVERT(SMALLINT, 4) AS BetType
			, CONVERT(SMALLINT, 1) AS OddsType
	
	)

GO
