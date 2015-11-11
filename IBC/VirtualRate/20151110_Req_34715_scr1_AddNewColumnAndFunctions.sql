/*
	Created: 20151021@Billy
	Task: Add new column to ProfileVirtualSetting table (UM Time)
	DB: DBCUST.CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	--
-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBACC/bodb02		--
----------------------------------------------------------

USE [CustDB]
GO
  
-- Add new column to ProfileVirtualSetting table --
ALTER TABLE [dbo].[ProfileVirtualSetting]
ADD isActive BIT NOT NULL DEFAULT 0
GO

-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	--
-- BEGIN STEP 4: DEPLOY THIS SCRIPT ON DBACC/bodb02		--
----------------------------------------------------------

USE [CustDB]
GO
 
-- Deploy functions needed for access new Virtual Rate Setting --
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Function [dbo].[f_GenerateVirtualSetting_multiple]
CREATE FUNCTION [dbo].[f_GenerateVirtualSetting_multiple] (@bitmap binary(64), @xmlStr varchar(max))   
RETURNS @outputTemp TABLE  
 (  
  bitmap binary(64)  
 )  
AS  
/*
	Created: Viet @ 15.OCT.2015
	DB: DBCust.custDB

	Revision:      
	Param's Explanation:   
		@xmlStr:   
			+ FORMAT: <root><r p="" v="" /></root>  
			+ r: row  
			+ p: profileID  
			+ v: virtualMultiplier
*/ 
BEGIN  
	DECLARE @xml XML = CONVERT(XML, @xmlStr)    		
	
	SELECT @bitmap = CONVERT(binary(64), STUFF(@bitmap, 1+(T.C.value('./@p', 'smallint')-1)%64, 1, CAST(CAST(T.C.value('./@v', 'smallmoney') * 100 as INT) as binary(1))))
	FROM @xml.nodes('/root/r') as [T](C) --T: table, C: column	

	INSERT INTO @outputTemp(bitmap)  
	SELECT @bitmap  

	RETURN  
END  
 
-- Function [dbo].[f_GenerateVirtualSetting]
CREATE FUNCTION [dbo].[f_GenerateVirtualSetting] (@bitmap binary(64), @profileID smallint, @virtualMultiplier smallmoney)  
	RETURNS binary(64) AS  
 /*  
	  Created: Viet @ 7.OCT.2015  
	  DB: DBCust.custDB  
  
	  Revision:      
	  Param's Explanation:  
 */  
BEGIN 	
	RETURN CONVERT(binary(64), STUFF(@bitmap, 1+((@profileID-1)%64), 1, CAST(CAST(@virtualMultiplier*100 as int) as binary(1))))
END

-- Function [dbo].[f_GetVirtualSetting]
ALTER FUNCTION [dbo].[f_GetVirtualSetting] (@bitmap binary(64), @profileID smallint)  
	RETURNS SMALLMONEY AS  
	/*
		Created: Viet @ 15.OCT.2015
		DB: DBCust.custDB

		Revision:				
		Param's Explanation:	
	*/
BEGIN		
	RETURN CAST(substring(@bitmap, 1+((@profileID-1)%64), 1) as int) / 100.0	
END
