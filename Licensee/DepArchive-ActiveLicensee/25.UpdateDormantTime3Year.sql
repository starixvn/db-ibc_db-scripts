/*
	Task: Update new dormant time for active licensees - Support #109528
	Creator: Dominic@20190228
	Run at: CustDB@DBCUST
*/
USE CustDB
GO

--Step 1: Config dormant time 3 years (1095 days) for 71 active licensees
UPDATE [CustDB].[dbo].[Dep_Customer_Archived_Config]
SET MinDays = 1095
WHERE site IN ('e8Casino ','DEWA ','PanguGame','Lucky88','818Bet','Unobet','Swin','Brown888','M8bola','IGPTech','ECLBET','396Club','NBCbet','BetStar','Heaven','VCBA','Hengcai88','Q8bola','GPIGAME','DBP','Taipanbet','HL8','Zzun88','Hecbet','88Macao','TGO','iBet','Mayayule','Royal','Dawoo','IBO','9bet','ITCBet','Webet138','TGame','MrCat','webet88','FLC','Sun988','Sunrise','Aoncash','Boma365','Senibet','OLE777','BE7','KhmerG','Salon365','Abcasino','3star88','PKbet','9Club','Vwin','Boying','HonorW','Liga','MayFair','HuangMa','Happy1668','Gampag','Macaubet','AG','Ae88','TLC','GamingSoft','SunGame','HONBET','Bodog','365online','KeenOcean','Newhonbet','Ty777')
AND status=0

--Step 2: Disable config for 15 active licensees those will be archived later
UPDATE [CustDB].[dbo].[Dep_Customer_Archived_Config]
SET status = 1 --disabled
WHERE site IN ('Webet138','TGame','MrCat','webet88','FLC','Sun988','Sunrise','KhmerG','PKbet','Boying','HuangMa','Gampag','TLC','365online','Ty777')
AND status=0

--Step 3: Not archive VCBA
UPDATE [CustDB].[dbo].[Dep_Customer_Archived_Config]
SET status = 1 --disabled
WHERE site='VCBA'
