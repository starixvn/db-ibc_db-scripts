USE [bodb_TGRS]
GO

SET NOCOUNT ON 

IF OBJECT_ID('tempdb..#Trader') IS NOT NULL
    DROP TABLE #Trader

SELECT ci.[CustId]
	  ,UPPER(td.[Username]) [Username]
      ,EmployeID [EmployeeId]
      ,ISNULL(te.[TeamId],1) [TeamId]
	  ,ISNULL(te.TeamName,1) TeamName
      ,CASE WHEN td.[Grade]='' THEN 10 ELSE td.[Grade] END [Grade] 
      ,ISNULL(ci.[creatdate],'2011-01-01') [CreatedDate]
      ,8 AS [CreatedBy]
      ,NULL [ModifiedDate]
      ,NULL [ModifiedBy]
      ,0 [Disabled]
      ,CONVERT(NVARCHAR(10),ISNULL(ci.[creatdate],'2011-01-01'),20) [TeamEffectiveDate]
      ,CONVERT(NVARCHAR(10),ISNULL(ci.[creatdate],'2011-01-01'),20) [GradeEffectiveDate] 
INTO #Trader
FROM (SELECT '1X2ANNIE' UserName,'3' Grade ,'1X2' Team,'00745' EmployeID
		UNION ALL SELECT '1X2JHEY' UserName,'3' Grade ,'1X2' Team,'00759' EmployeID
		UNION ALL SELECT '1X2ARNOLD' UserName,'3' Grade ,'1X2' Team,'02220' EmployeID
		UNION ALL SELECT '1X2BELLE' UserName,'3' Grade ,'1X2' Team,'02494' EmployeID
		UNION ALL SELECT '1x2BURKE' UserName,'3' Grade ,'1X2' Team,'02384' EmployeID
		UNION ALL SELECT '1X2CAMS' UserName,'3' Grade ,'1X2' Team,'02487' EmployeID
		UNION ALL SELECT '1X2CAT' UserName,'3' Grade ,'1X2' Team,'02196' EmployeID
		UNION ALL SELECT '1X2CHELLE' UserName,'3' Grade ,'1X2' Team,'01099' EmployeID
		UNION ALL SELECT '1X2DAPHNIE' UserName,'3' Grade ,'1X2' Team,'02219' EmployeID
		UNION ALL SELECT '1X2DES' UserName,'3' Grade ,'1X2' Team,'02206' EmployeID
		UNION ALL SELECT '1X2DONNA' UserName,'3' Grade ,'1X2' Team,'02221' EmployeID
		UNION ALL SELECT '1X2EARL' UserName,'3' Grade ,'1X2' Team,'02364' EmployeID
		UNION ALL SELECT '1x2ECHO' UserName,'3' Grade ,'1X2' Team,'02379' EmployeID
		UNION ALL SELECT '1X2EK' UserName,'3' Grade ,'1X2' Team,'02518' EmployeID
		UNION ALL SELECT '1X2ELAINE' UserName,'3' Grade ,'1X2' Team,'02235' EmployeID
		UNION ALL SELECT '1X2ETHEL' UserName,'3' Grade ,'1X2' Team,'02488' EmployeID
		UNION ALL SELECT '1X2EU' UserName,'3' Grade ,'1X2' Team,'02365' EmployeID
		UNION ALL SELECT '1X2FIVIE' UserName,'3' Grade ,'1X2' Team,'02486' EmployeID
		UNION ALL SELECT '1X2GILDA' UserName,'3' Grade ,'1X2' Team,'02232' EmployeID
		UNION ALL SELECT '1X2GRACE' UserName,'3' Grade ,'1X2' Team,'02237' EmployeID
		UNION ALL SELECT '1X2JANE' UserName,'3' Grade ,'1X2' Team,'02234' EmployeID
		UNION ALL SELECT '1X2JASON' UserName,'3' Grade ,'1X2' Team,'02200' EmployeID
		UNION ALL SELECT '1X2JEF' UserName,'3' Grade ,'1X2' Team,'02204' EmployeID
		UNION ALL SELECT '1x2JHOR' UserName,'3' Grade ,'1X2' Team,'02382' EmployeID
		UNION ALL SELECT '1X2JM' UserName,'3' Grade ,'1X2' Team,'02233' EmployeID
		UNION ALL SELECT 'LGMIN' UserName,'4' Grade ,'Others' Team,'00220' EmployeID
		UNION ALL SELECT '1X2JOY' UserName,'3' Grade ,'1X2' Team,'02243' EmployeID
		UNION ALL SELECT '1X2KARL' UserName,'3' Grade ,'1X2' Team,'02205' EmployeID
		UNION ALL SELECT '1x2king' UserName,'3' Grade ,'1X2' Team,'01004' EmployeID
		UNION ALL SELECT '1X2LES' UserName,'3' Grade ,'1X2' Team,'02493' EmployeID
		UNION ALL SELECT 'LGHENDRA' UserName,'2' Grade ,'Team F' Team,'01195' EmployeID
		UNION ALL SELECT '1X2MAT' UserName,'3' Grade ,'1X2' Team,'02207' EmployeID
		UNION ALL SELECT '1X2MEL' UserName,'3' Grade ,'1X2' Team,'02198' EmployeID
		UNION ALL SELECT '1X2NIKKI' UserName,'3' Grade ,'1X2' Team,'02215' EmployeID
		UNION ALL SELECT '1X2NOLI' UserName,'3' Grade ,'1X2' Team,'02224' EmployeID
		UNION ALL SELECT '1X2PHILIP' UserName,'3' Grade ,'1X2' Team,'02383' EmployeID
		UNION ALL SELECT '1X2PJ' UserName,'3' Grade ,'1X2' Team,'02227' EmployeID
		UNION ALL SELECT '1X2PONG' UserName,'3' Grade ,'1X2' Team,'02195' EmployeID
		UNION ALL SELECT '1x2RALPH' UserName,'3' Grade ,'1X2' Team,'02381' EmployeID
		UNION ALL SELECT '1x2RAV' UserName,'3' Grade ,'1X2' Team,'02492' EmployeID
		UNION ALL SELECT '1X2REBO' UserName,'3' Grade ,'1X2' Team,'02208' EmployeID
		UNION ALL SELECT '1X2RL' UserName,'3' Grade ,'1X2' Team,'02239' EmployeID
		UNION ALL SELECT '1X2SAI' UserName,'3' Grade ,'1X2' Team,'02385' EmployeID
		UNION ALL SELECT '1X2SHANE' UserName,'3' Grade ,'1X2' Team,'02491' EmployeID
		UNION ALL SELECT '1X2SHE' UserName,'3' Grade ,'1X2' Team,'02223' EmployeID
		UNION ALL SELECT '1X2TIN' UserName,'3' Grade ,'1X2' Team,'02222' EmployeID
		UNION ALL SELECT '1X2VINCE' UserName,'3' Grade ,'1X2' Team,'02241' EmployeID
		UNION ALL SELECT '1X2YANI' UserName,'3' Grade ,'1X2' Team,'02489' EmployeID
		UNION ALL SELECT '1X2ZHO' UserName,'3' Grade ,'1X2' Team,'02226' EmployeID
		UNION ALL SELECT 'ABDBOONLAY' UserName,'4' Grade ,'Others' Team,'00873' EmployeID
		UNION ALL SELECT 'CHAI' UserName,'1' Grade ,'Team C' Team,'00850' EmployeID
		UNION ALL SELECT 'CHANG' UserName,'2' Grade ,'Team I' Team,'00029' EmployeID
		UNION ALL SELECT 'CHIAN' UserName,'1' Grade ,'Team C' Team,'00851' EmployeID
		UNION ALL SELECT 'FEI' UserName,'2' Grade ,'Others' Team,'00053' EmployeID
		UNION ALL SELECT 'JIAMING' UserName,'1' Grade ,'Team C' Team,'00032' EmployeID
		UNION ALL SELECT 'KENNITH' UserName,'3' Grade ,'1X2' Team,'02199' EmployeID
		UNION ALL SELECT 'KIMMY' UserName,'3' Grade ,'Others' Team,'02197' EmployeID
		UNION ALL SELECT 'LGAARON' UserName,'3' Grade ,'Team D' Team,'00358' EmployeID
		UNION ALL SELECT 'LGAIK' UserName,'1' Grade ,'Team G' Team,'00230' EmployeID
		UNION ALL SELECT 'LGALIKIN' UserName,'4' Grade ,'Team D' Team,'02209' EmployeID
		UNION ALL SELECT 'LGANTON' UserName,'4' Grade ,'Team I' Team,'01205' EmployeID
		UNION ALL SELECT 'LGASOON' UserName,'2' Grade ,'Team C' Team,'00023' EmployeID
		UNION ALL SELECT 'LGBARON' UserName,'5' Grade ,'Team B' Team,'00565' EmployeID
		UNION ALL SELECT 'LGBAY' UserName,'4' Grade ,'Team I' Team,'01029' EmployeID
		UNION ALL SELECT 'LGYAMY' UserName,'4' Grade ,'Team F' Team,'01940' EmployeID
		UNION ALL SELECT 'LGBENG' UserName,'2' Grade ,'Team A' Team,'00095' EmployeID
		UNION ALL SELECT 'LGBOON' UserName,'1' Grade ,'Others' Team,'00204' EmployeID
		UNION ALL SELECT 'LGBOY' UserName,'2' Grade ,'Team B' Team,'00132' EmployeID
		UNION ALL SELECT 'LGCAM' UserName,'3' Grade ,'Team D' Team,'02203' EmployeID
		UNION ALL SELECT 'LGEPOY' UserName,'4' Grade ,'Team F' Team,'01942' EmployeID
		UNION ALL SELECT 'LGCHEE' UserName,'4' Grade ,'Team C' Team,'00113' EmployeID
		UNION ALL SELECT 'LGCHEN' UserName,'2' Grade ,'Team H' Team,'00059' EmployeID
		UNION ALL SELECT 'LGTECKPING' UserName,'1' Grade ,'Team D' Team,'01198' EmployeID
		UNION ALL SELECT 'LGCHRIS' UserName,'10' Grade ,'Others' Team,'00313' EmployeID
		UNION ALL SELECT 'LGCHUAN' UserName,'3' Grade ,'Team A' Team,'00094' EmployeID
		UNION ALL SELECT 'LGCKEEN' UserName,'3' Grade ,'Team C' Team,'00074' EmployeID
		UNION ALL SELECT 'LGCORY' UserName,'4' Grade ,'Team A' Team,'00891' EmployeID
		UNION ALL SELECT 'LGDUCAN' UserName,'4' Grade ,'Team D' Team,'00395' EmployeID
		UNION ALL SELECT 'LGDUY' UserName,'4' Grade ,'Team D' Team,'01854' EmployeID
		UNION ALL SELECT 'LGEDY' UserName,'4' Grade ,'Team F' Team,'01203' EmployeID
		UNION ALL SELECT 'LGCHRIS1' UserName,'3' Grade ,'Team A' Team,'00313' EmployeID
		UNION ALL SELECT 'LGEVEN' UserName,'3' Grade ,'Team I' Team,'00631' EmployeID
		UNION ALL SELECT 'LGFAI' UserName,'2' Grade ,'Team C' Team,'90027' EmployeID
		UNION ALL SELECT 'LGFU' UserName,'4' Grade ,'Team B' Team,'90028' EmployeID
		UNION ALL SELECT 'LGGARY' UserName,'2' Grade ,'Team D' Team,'00241' EmployeID
		UNION ALL SELECT 'LGGEE' UserName,'2' Grade ,'Team F' Team,'00041' EmployeID
		UNION ALL SELECT 'LGNEO' UserName,'4' Grade ,'Team E' Team,'00462' EmployeID
		UNION ALL SELECT 'LGGOH' UserName,'4' Grade ,'Team A' Team,'00121' EmployeID
		UNION ALL SELECT 'LGCANDY' UserName,'4' Grade ,'Team H' Team,'00354' EmployeID
		UNION ALL SELECT 'LGHAN' UserName,'1' Grade ,'Team H' Team,'00229' EmployeID
		UNION ALL SELECT 'LGHANWEI' UserName,'4' Grade ,'Team C' Team,'00579' EmployeID
		UNION ALL SELECT 'LGHARTONO' UserName,'4' Grade ,'Team E' Team,'02210' EmployeID
		UNION ALL SELECT 'PHANNIE' UserName,'3' Grade ,'1X2' Team,'00328' EmployeID
		UNION ALL SELECT 'LGHENG' UserName,'4' Grade ,'Team C' Team,'00114' EmployeID
		UNION ALL SELECT 'LGHO' UserName,'1' Grade ,'Team B' Team,'00098' EmployeID
		UNION ALL SELECT 'LGHONHENG' UserName,'4' Grade ,'Team A' Team,'00118' EmployeID
		UNION ALL SELECT 'LGHONLIANG' UserName,'4' Grade ,'Others' Team,'00207' EmployeID
		UNION ALL SELECT 'LGHONSANG' UserName,'2' Grade ,'Team B' Team,'00119' EmployeID
		UNION ALL SELECT 'LGHUAT' UserName,'2' Grade ,'Team A' Team,'00124' EmployeID
		UNION ALL SELECT 'LGJACKY' UserName,'1' Grade ,'Team B' Team,'00107' EmployeID
		UNION ALL SELECT 'LGJAMES' UserName,'5' Grade ,'Team E' Team,'00403' EmployeID
		UNION ALL SELECT 'LGJENNY' UserName,'3' Grade ,'Team H' Team,'00344' EmployeID
		UNION ALL SELECT 'LGJON' UserName,'3' Grade ,'Team D' Team,'01196' EmployeID
		UNION ALL SELECT 'LGJULIE' UserName,'2' Grade ,'Team A' Team,'00337' EmployeID
		UNION ALL SELECT 'LGKELVEN' UserName,'2' Grade ,'Team G' Team,'00346' EmployeID
		UNION ALL SELECT 'LGKENJI' UserName,'1' Grade ,'Others' Team,'00208' EmployeID
		UNION ALL SELECT 'LGKENTHAM' UserName,'4' Grade ,'Team A' Team,'00078' EmployeID
		UNION ALL SELECT 'LGKERN' UserName,'3' Grade ,'Team I' Team,'00227' EmployeID
		UNION ALL SELECT 'LGKIEN' UserName,'2' Grade ,'Team A' Team,'00076' EmployeID
		UNION ALL SELECT 'LGKILOS' UserName,'2' Grade ,'Team E' Team,'00218' EmployeID
		UNION ALL SELECT 'LGKit1' UserName,'1' Grade ,'Team A' Team,'00116' EmployeID
		UNION ALL SELECT 'LGKOKCHEN' UserName,'3' Grade ,'Team E' Team,'00231' EmployeID
		UNION ALL SELECT 'LGKRIS' UserName,'4' Grade ,'Team B' Team,'00667' EmployeID
		UNION ALL SELECT 'LGKUIK' UserName,'2' Grade ,'Team B' Team,'00073' EmployeID
		UNION ALL SELECT 'LGLEE' UserName,'4' Grade ,'Team B' Team,'00111' EmployeID
		UNION ALL SELECT 'LGLIM' UserName,'2' Grade ,'Team H' Team,'00210' EmployeID
		UNION ALL SELECT 'LGLINA' UserName,'2' Grade ,'Team B' Team,'00307' EmployeID
		UNION ALL SELECT 'LGLIPINO' UserName,'5' Grade ,'Team I' Team,'02207' EmployeID
		UNION ALL SELECT 'LGLONG' UserName,'1' Grade ,'Team F' Team,'00214' EmployeID
		UNION ALL SELECT 'LGLUKE' UserName,'3' Grade ,'Team I' Team,'00619' EmployeID
		UNION ALL SELECT 'LGMAN' UserName,'3' Grade ,'Team G' Team,'00432' EmployeID
		UNION ALL SELECT 'LGMARCO' UserName,'4' Grade ,'Team E' Team,'00394' EmployeID
		UNION ALL SELECT 'LGMAX' UserName,'4' Grade ,'Team I' Team,'00209' EmployeID
		UNION ALL SELECT 'LGMICHELLE' UserName,'4' Grade ,'Team G' Team,'00446' EmployeID
		UNION ALL SELECT '1X2MARGE' UserName,'3' Grade ,'1X2' Team,'02230' EmployeID
		UNION ALL SELECT 'LGSOONG' UserName,'2' Grade ,'Team F' Team,'00079' EmployeID
		UNION ALL SELECT 'LGMING' UserName,'4' Grade ,'Team A' Team,'00112' EmployeID
		UNION ALL SELECT 'LGNARSI' UserName,'4' Grade ,'Team C' Team,'00649' EmployeID
		UNION ALL SELECT '1X2AM' UserName,'3' Grade ,'1X2' Team,'02197' EmployeID
		UNION ALL SELECT 'LGNG' UserName,'4' Grade ,'Team I' Team,'01202' EmployeID
		UNION ALL SELECT 'LGNICKY' UserName,'4' Grade ,'Team D' Team,'02222' EmployeID
		UNION ALL SELECT 'LGNIKKOL' UserName,'4' Grade ,'Team I' Team,'00634' EmployeID
		UNION ALL SELECT 'LGONN' UserName,'4' Grade ,'Team A' Team,'00099' EmployeID
		UNION ALL SELECT 'LGPARKER' UserName,'2' Grade ,'Team E' Team,'00529' EmployeID
		UNION ALL SELECT 'LGPENG' UserName,'4' Grade ,'Team F' Team,'00226' EmployeID
		UNION ALL SELECT 'LGWEN' UserName,'2' Grade ,'Team G' Team,'00105' EmployeID
		UNION ALL SELECT 'LGPIAU' UserName,'3' Grade ,'Team I' Team,'00213' EmployeID
		UNION ALL SELECT 'LGPING' UserName,'3' Grade ,'Team B' Team,'00115' EmployeID
		UNION ALL SELECT 'LGPOW' UserName,'4' Grade ,'Team F' Team,'00212' EmployeID
		UNION ALL SELECT 'LGRANDY' UserName,'5' Grade ,'Team A' Team,'00417' EmployeID
		UNION ALL SELECT 'LGRAYMOND' UserName,'1' Grade ,'Team A' Team,'00106' EmployeID
		UNION ALL SELECT 'LGRECCA' UserName,'4' Grade ,'Team A' Team,'01615' EmployeID
		UNION ALL SELECT 'LGRINO' UserName,'2' Grade ,'Team G' Team,'00611' EmployeID
		UNION ALL SELECT 'LGRYAN' UserName,'1' Grade ,'Team E' Team,'00232' EmployeID
		UNION ALL SELECT 'LGSAELEE' UserName,'2' Grade ,'Team D' Team,'02206' EmployeID
		UNION ALL SELECT 'LGSAN' UserName,'4' Grade ,'Team H' Team,'00487' EmployeID
		UNION ALL SELECT 'LGSANDY' UserName,'4' Grade ,'Team G' Team,'00450' EmployeID
		UNION ALL SELECT 'LGSCOTT' UserName,'4' Grade ,'Team E' Team,'00423' EmployeID
		UNION ALL SELECT 'LGSEANG' UserName,'4' Grade ,'Team H' Team,'00225' EmployeID
		UNION ALL SELECT 'LGSERN' UserName,'4' Grade ,'Team C' Team,'00120' EmployeID
		UNION ALL SELECT 'LGSHOOTBIRD' UserName,'1' Grade ,'Others' Team,'00203' EmployeID
		UNION ALL SELECT 'LGSHUAN' UserName,'1' Grade ,'Team H' Team,'00219' EmployeID
		UNION ALL SELECT 'LGSIANG' UserName,'3' Grade ,'Team D' Team,'00224' EmployeID
		UNION ALL SELECT 'LGBEN' UserName,'3' Grade ,'Team B' Team,'00392' EmployeID
		UNION ALL SELECT 'LGSOPHIA' UserName,'4' Grade ,'Team G' Team,'00449' EmployeID
		UNION ALL SELECT 'LGSUSAN' UserName,'3' Grade ,'Team I' Team,'00898' EmployeID
		UNION ALL SELECT 'LGTAI' UserName,'4' Grade ,'Team C' Team,'00084' EmployeID
		UNION ALL SELECT 'LGTECK' UserName,'3' Grade ,'Team B' Team,'00123' EmployeID
		UNION ALL SELECT 'LGGREEN' UserName,'3' Grade ,'Team G' Team,'00618' EmployeID
		UNION ALL SELECT 'LGTEOH' UserName,'2' Grade ,'Others' Team,'00215' EmployeID
		UNION ALL SELECT 'LGTOM' UserName,'2' Grade ,'Team C' Team,'02431' EmployeID
		UNION ALL SELECT 'LGTOMMY' UserName,'1' Grade ,'Team G' Team,'01204' EmployeID
		UNION ALL SELECT 'LGTONY' UserName,'4' Grade ,'Team F' Team,'00452' EmployeID
		UNION ALL SELECT 'LGTONYKHO' UserName,'4' Grade ,'Team H' Team,'00289' EmployeID
		UNION ALL SELECT 'LGVICO' UserName,'4' Grade ,'Team D' Team,'00582' EmployeID
		UNION ALL SELECT 'LGVINH' UserName,'4' Grade ,'Team I' Team,'00236' EmployeID
		UNION ALL SELECT 'LGWEI' UserName,'4' Grade ,'Team C' Team,'00087' EmployeID
		UNION ALL SELECT 'LGGILLIAN' UserName,'4' Grade ,'Team G' Team,'00430' EmployeID
		UNION ALL SELECT 'LGWUBAI' UserName,'2' Grade ,'Team C' Team,'00044' EmployeID
		UNION ALL SELECT 'LGWUI' UserName,'4' Grade ,'Team A' Team,'00122' EmployeID
		UNION ALL SELECT 'LGXAVI' UserName,'3' Grade ,'Team E' Team,'00895' EmployeID
		UNION ALL SELECT 'LGXING' UserName,'1' Grade ,'Team B' Team,'00075' EmployeID
		UNION ALL SELECT 'U13HUGO' UserName,'4' Grade ,'Team C' Team,'00393' EmployeID
		UNION ALL SELECT 'LGYAO' UserName,'4' Grade ,'Team G' Team,'00245' EmployeID
		UNION ALL SELECT 'LGYAP' UserName,'3' Grade ,'Team A' Team,'00100' EmployeID
		UNION ALL SELECT 'LGYEN' UserName,'2' Grade ,'Team B' Team,'00093' EmployeID
		UNION ALL SELECT 'LGYEW' UserName,'5' Grade ,'Team B' Team,'00117' EmployeID
		UNION ALL SELECT 'LGYING' UserName,'1' Grade ,'Team F' Team,'00228' EmployeID
		UNION ALL SELECT 'LGYUAN' UserName,'2' Grade ,'Team E' Team,'00222' EmployeID
		UNION ALL SELECT 'LGYUEMING' UserName,'5' Grade ,'Team H' Team,'00223' EmployeID
		UNION ALL SELECT 'LOON' UserName,'2' Grade ,'Others' Team,'00085' EmployeID
		UNION ALL SELECT 'MTDLALBERT' UserName,'4' Grade ,'Others' Team,'00679' EmployeID
		UNION ALL SELECT 'MTDLFRANK' UserName,'4' Grade ,'Others' Team,'00488' EmployeID
		UNION ALL SELECT 'MTDLJAY' UserName,'' Grade ,'Others' Team,'00493' EmployeID
		UNION ALL SELECT 'MTDLKID' UserName,'4' Grade ,'Others' Team,'00617' EmployeID
		UNION ALL SELECT 'MTDLLAM' UserName,'4' Grade ,'Others' Team,'00530' EmployeID
		UNION ALL SELECT 'MTDLMATHEW' UserName,'5' Grade ,'Others' Team,'02580' EmployeID
		UNION ALL SELECT 'MTDLMESSI' UserName,'4' Grade ,'Others' Team,'00541' EmployeID
		UNION ALL SELECT 'MTDLNESTA' UserName,'4' Grade ,'Others' Team,'00047' EmployeID
		UNION ALL SELECT 'MTDLZON' UserName,'5' Grade ,'Others' Team,'00913' EmployeID
		UNION ALL SELECT 'PAU' UserName,'1' Grade ,'Others' Team,'00036' EmployeID
		UNION ALL SELECT 'PHALLEN' UserName,'3' Grade ,'1X2' Team,'00600' EmployeID
		UNION ALL SELECT '1X2JO' UserName,'3' Grade ,'1X2' Team,'00746' EmployeID
		UNION ALL SELECT 'PHBOO' UserName,'3' Grade ,'1X2' Team,'02503' EmployeID
		UNION ALL SELECT 'PHBRITNEY' UserName,'3' Grade ,'1X2' Team,'00596' EmployeID
		UNION ALL SELECT 'PHCRYSTAL' UserName,'3' Grade ,'1X2' Team,'02485' EmployeID
		UNION ALL SELECT 'PHDALLAS' UserName,'3' Grade ,'1X2' Team,'02335' EmployeID
		UNION ALL SELECT 'PHDante' UserName,'3' Grade ,'1X2' Team,'02656' EmployeID
		UNION ALL SELECT 'pheda' UserName,'3' Grade ,'1X2' Team,'02624' EmployeID
		UNION ALL SELECT 'PHHANA' UserName,'3' Grade ,'1X2' Team,'02265' EmployeID
		UNION ALL SELECT 'PHHELI' UserName,'3' Grade ,'1X2' Team,'02195' EmployeID
		UNION ALL SELECT 'PHJAESING' UserName,'3' Grade ,'1X2' Team,'02486' EmployeID
		UNION ALL SELECT 'PHJANICE' UserName,'3' Grade ,'1X2' Team,'02205' EmployeID
		UNION ALL SELECT 'PHJANNY' UserName,'3' Grade ,'1X2' Team,'02517' EmployeID
		UNION ALL SELECT 'PHJAYDEN' UserName,'3' Grade ,'1X2' Team,'02502' EmployeID
		UNION ALL SELECT 'PHJOJO' UserName,'3' Grade ,'1X2' Team,'02473' EmployeID
		UNION ALL SELECT 'PHJOY' UserName,'3' Grade ,'1X2' Team,'00431' EmployeID
		UNION ALL SELECT 'PHKARLA' UserName,'3' Grade ,'1X2' Team,'01607' EmployeID
		UNION ALL SELECT 'PHKATIE' UserName,'3' Grade ,'1X2' Team,'00461' EmployeID
		UNION ALL SELECT 'PHKOTARO' UserName,'3' Grade ,'1X2' Team,'02495' EmployeID
		UNION ALL SELECT 'PHLEVI' UserName,'3' Grade ,'1X2' Team,'02667' EmployeID
		UNION ALL SELECT 'PHLUCAS' UserName,'3' Grade ,'1X2' Team,'02379' EmployeID
		UNION ALL SELECT 'PHMICHELL' UserName,'3' Grade ,'1X2' Team,'02499' EmployeID
		UNION ALL SELECT 'PHRONALD' UserName,'3' Grade ,'1X2' Team,'02666' EmployeID
		UNION ALL SELECT 'PHSEVEN' UserName,'3' Grade ,'1X2' Team,'00969' EmployeID
		UNION ALL SELECT 'PHSHEAMUS' UserName,'3' Grade ,'1X2' Team,'02427' EmployeID
		UNION ALL SELECT 'PHShelly' UserName,'3' Grade ,'1X2' Team,'02451' EmployeID
		UNION ALL SELECT 'PHSTAVEN' UserName,'3' Grade ,'1X2' Team,'02425' EmployeID
		UNION ALL SELECT 'PHSTELLA' UserName,'3' Grade ,'1X2' Team,'02641' EmployeID
		UNION ALL SELECT 'PHTAPO' UserName,'3' Grade ,'1X2' Team,'02655' EmployeID
		UNION ALL SELECT 'PHTERRY' UserName,'3' Grade ,'1X2' Team,'02601' EmployeID
		UNION ALL SELECT 'PHTEVEZ' UserName,'3' Grade ,'1X2' Team,'00546' EmployeID
		UNION ALL SELECT 'PHTREVOR' UserName,'3' Grade ,'1X2' Team,'02501' EmployeID
		UNION ALL SELECT 'PHWILLION' UserName,'3' Grade ,'1X2' Team,'02642' EmployeID
		UNION ALL SELECT 'PHWISE' UserName,'3' Grade ,'1X2' Team,'02424' EmployeID
		UNION ALL SELECT 'PLANG' UserName,'4' Grade ,'Team C' Team,'00045' EmployeID
		UNION ALL SELECT 'RNDBAO' UserName,'4' Grade ,'Others' Team,'00089' EmployeID
		UNION ALL SELECT 'RNDCHEONG' UserName,'4' Grade ,'Others' Team,'00090' EmployeID
		UNION ALL SELECT 'ROTI' UserName,'4' Grade ,'Team D' Team,'00040' EmployeID
		UNION ALL SELECT 'STOSCAR' UserName,'5' Grade ,'Others' Team,'00569' EmployeID
		UNION ALL SELECT 'LGPETER' UserName,'4' Grade ,'Team H' Team,'00347' EmployeID
		UNION ALL SELECT 'U3HARIPON' UserName,'4' Grade ,'Others' Team,'01206' EmployeID

) td 
INNER JOIN  bodb02.dbo.Customer ci WITH (NOLOCK)			ON td.UserName = ci.UserName 
LEFT JOIN  [bodb_TGRS].dbo.[Team] te WITH (NOLOCK) 	ON td.Team = te.TeamName


INSERT INTO [dbo].[Trader]
           ([CustId]
           ,[Username]
           ,[EmployeeId]
           ,[TeamId]
           ,[Grade]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy]
           ,[Disabled]
           ,[TeamEffectiveDate]
           ,[GradeEffectiveDate])
SELECT td.[CustId]
           ,td.[Username]
           ,td.[EmployeeId]
           ,td.[TeamId]
           ,td.[Grade]
           ,td.[CreatedDate]
           ,td.[CreatedBy]
           ,td.[ModifiedDate]
           ,td.[ModifiedBy]
           ,td.[Disabled]
           ,td.[TeamEffectiveDate]
           ,td.[GradeEffectiveDate] 
FROM #Trader td
  LEFT JOIN  [bodb_TGRS].dbo.[Trader] tr_h WITH (NOLOCK) 	ON tr_h.CustId = td.custid 
  WHERE tr_h.CustId IS NULL

INSERT INTO [bodb_TGRS].[dbo].[TraderGrade_History]
           ([CustId]
           ,[Grade]
           ,[BeginDate]
           ,[EndDate])
	SELECT td.[CustId]
		  ,td.[Grade] [Grade]
		  ,td.[GradeEffectiveDate] [BeginDate]
		  ,NULL [EndDate]
	FROM #Trader td
		LEFT JOIN  [bodb_TGRS].dbo.[TraderGrade_History] trg_h WITH (NOLOCK) 	ON trg_h.CustId = td.custid 
	  WHERE trg_h.CustId IS NULL

INSERT INTO [bodb_TGRS].[dbo].[TraderTeam_History]
           ([CustId]
           ,[TeamId]
           ,[BeginDate]
           ,[EndDate])
	SELECT td.[CustId]
		  ,td.TeamId
		  ,td.[TeamEffectiveDate] [BeginDate]
		  ,NULL [EndDate]
	  FROM #Trader td
	  LEFT JOIN  [bodb_TGRS].dbo.[TraderTeam_History] trt_h WITH (NOLOCK) 		ON trt_h.CustId = td.custid
	  WHERE trt_h.CustId IS NULL
 
IF OBJECT_ID('tempdb..#Trader') IS NOT NULL    DROP TABLE #Trader
