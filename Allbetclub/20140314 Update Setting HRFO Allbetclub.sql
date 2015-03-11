/*
	Request: update setting for new accounts of Allbetclub
	Owner: Julien
	Date: 14-Mar-14
*/

-- Update maxpermatch and disable HR fixed odds DBTrans @ CustDB
UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET maxpermatch154 = maxpermatch99,
	DisableHRFixedOdds = 0
WHERE srecommend in (select custid from Dep_CustSuper with (nolock)
		where site = 'Allbetclub')

-- Insert setting for HRFO DBTrans @ CustDB
INSERT INTO [dbo].[Dep_CustSetting]
			   ([custid]
			   ,[bettype]
			   ,[sporttype]
			   ,[islive]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[minbet]
			   ,[maxbet])
	SELECT [custid]
		   ,20 as [bettype]
		   ,154 as [sporttype]
		   ,[islive]
		   ,[apositiontaking]
		   ,[mpositiontaking]
		   ,[spositiontaking]
		   ,[playerdiscount]
		   ,[discount]
		   ,[adiscount]
		   ,[sdiscount]
		   ,[minbet]
		   ,[maxbet]
	FROM Dep_CustSetting with(NOLOCK)
	WHERE custid IN (SELECT c.custid 
					FROM custinfo c with(NOLOCK) left join Dep_CustSetting cs with (nolock)
						on c.custid = cs.custid and cs.sporttype = 154 and cs.bettype = 20
					WHERE c.srecommend in (select custid 
											from Dep_CustSuper with (nolock)
											where site = 'Allbetclub') 
						And cs.custid is null
				)	
		AND sporttype = 99
		AND bettype = 20