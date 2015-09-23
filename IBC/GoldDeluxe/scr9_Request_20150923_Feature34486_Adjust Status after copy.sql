 /*
	Created: Johnson
	Task: Adjust status after copy setting for agents in enable sheet
	DB: DBTXN/CustDB
	Date: 20150923
*/  


--step 0: check status of agent before run this step
--if no agent change status, no need to run
--agents list follow live casino status

--agents list need to enable 
 
SELECT custid, roleid, DisableLivecasino as Disable
INTO #tmpAdjustAgent
FROM custifno WITH(NOLOCK)
WHERE USEname IN ('M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','S359HL','S359RM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAE','DAF','HX','DAM','HN','HQ','TKRM','WBRMB','WBR','WBRR','WBRA','wbrf','WBRG','WBRH','WBRI','WBRJ','TG1','TG3','TG2','TG4','CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T','B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T','B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','SKKM','ywrm','6599RM','SALR','SALH','MALM','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM','TED','THH','THS','TEG','THT','MAMRM','SMAMRMB','SAMR','M25RM','M25ARMB','M25BRMB','S25R','M25HK','S25RM','L25RM','MMYBRM','MMYBH','BYS','MBY','BYM','BYU','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IK','IJ','AN','WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA','AQ','AD','WJ','WG','HI','BI','BJ','LI','LW','UI','II','IA','IE','IG','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','AW','AG','AF','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM','AL','DB','SD','CJEU','M26RMB','M26ARMB','M26RM','M26SD','M26BRMB','M26ARM','S26H','M26BRM','M252RMB','M252H','SCHK','SCM','SCS','SCSM','SCH','SCAH','SCAI','SCI','SCBH','SCHI','SCDH','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69BP','S69HD','S69RP','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK','S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II','S56UH','S56VH','S56A','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','HK07','S56ASD','HK09','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','S36RMB','S36RM','SD1R','s79rrr','S79RM','S79AR','S79R','S79H','S79AHH','S79HH','S79HK','S799H','S79SH','M79H','S79HG','S79hz','S79CR','S79HS','S79I','S79C','WD1','WD2','WD3','S79RMB','M79U','WDD','WDE','WDH','WDI','WDJ','WDK','WDL','M79V','WDR','WD','WC','WD7','S49RM','S49R','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S60RUP','S60AR','D60','E60','S16RUP','6666HK','6666BP','6666US','6666EU','M6HK','6hk6601','M6SD','6666AUD','S6EU','S6RUP','S6US','S6ARUP','M6RM','AA','BA','6666AHK','DA','6666AEU','MPH','JPG','S6H','FA','VC','S6BP','VD','VM','VF','GA','VO','GG','s6cn','VP','VQ','S6HK','S6RMB','FM','S6P','VI','VE','VA','VG','MD','S9EU','S6T','VJ','S6S','S6AHK','S88D','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEM','SEI','SEH','SED','SEK','SEMA','MJRMB','SJM','SJH','SJSD','SBHK','S305CRMB','S305RM','S31RM','S31RMB','S305R','S31ARMB','SSFH','SSF1H','S3H','SSF2H','SSF3H','MSFR','SSFK','S3HH','SSF5H','S31BRM','S3HK','S305M','S3HG','S3HJ','S3HP','SSF6H','SHSD','SHRMB','SHTB','SHHK','hhm','SHKK','SHHT','SHDK','SHHK1','SHHK2','SHR','SHR1','SHHK3','SHI','shhk5','SHR3','shhk6','SHR5','SHHK7','hhma','sh8','SHHK9','HHN','SHHK8','HHK1','HHK10','HHK2','HHK3','HHR','HHK4','BHJ','CFT','TT','TTA','TTB','S2R','S2T','S2AR','S2BR','S2TB','S688R','S688H','S788H','S688T','S688AH','S688M','LP','LLP','LLR','A68US','A688U','SAKH','SAKM','DKE','DKD','M8H','SWU','SWK','SWM','S2H','S2M','S2HH','S2MM','S2MN','S2HY','MRTB','MKWRM','SRRMB','SKWRMB','SRARMB','SRRH','SRR','SRH','SRHK','SRRR','SRMA','SRHKA','SRJ','SRKH','SRHH','SRMB','SRK','SRHC','SRHD','SRMC','SRQ','SMQARMB','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK','S99HKK','S99HKD','S99BH','S99TH','S99RMB','S999TB','S99C','S99THB','S99D','S99MHK','S99CH','S99BT','S99HA','S99TC','S99E','S99BA','S99BB','S99BC','S99BD','WKH','S45H','s45m','S45AH','S45BH','S45AM','S45BM','S45HK','KJH','KJHB','KJM','KJI','KJD','KJT','KJMB','KJK','KJE','KJB','KJC','KJF','KJMC','KJMA','KJG','KJMD','KJL','KJO','KJME','KJMF','AHM','AHN','AHI','AHO','BHO','AHP','AHQ','AHR','BHN','AHH','AHE','bhu','AHF','AHD','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2','GMG','BKK','S41S','S41M','S41H','S43S','S43H','S41K','MC','MC1','MC2','MCR','MC3','MC5','LJ','LH','LU','LY','LL','LB','LC','LD','LE','LV','LF','LT','KD','KL','HA','LS','LA','LG','LM','LII','LZ','BGR','CHU','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPI','HPZ','HPR','HPJ','HPH','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPE','HPA','MO','MP','HPG','HPB','HPF','HPL','SX5','MQ','SX6','HP2','MG','SX7','SX8','HTB','HPS','HPM2','HP1','HPT','HP3','SX9','HSS','HMN','SATU','SATE','SATS','SATM','JS','JS1','JM','JS2','SFH','JS3','JS5','JS6','JS7','JS8','SJS','SFHA','JS9','JSA','JSC','JSB','JSD','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSH','JSK','JSL','JSM','JR','JSZ','SHG','JSN','JSP','JSU','JRA','JSV','JSW','JSX','JSY','JTH','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHH','JHJ','SAS','ASA','SAE','SAI','ASB','M71RMB','M71ARMB','M71BRMB','M71CRMB','S71RM','M71DRMB','SER','S71H','S71AH','S71M','S71BH','S71MA','S71CH','S71DH','S71MB','SCLH','SCLM','SMT','SBTM','SBTH','SBTK','SBTN','SBTD','SBTL','SBTR','SBTY','SKHH','SKMM','PKK','PKA','PKB','PKRM','PKID','PKC','PKD','PKE','PKF','MPKS','PKG','PKH','PKJ','PKL','PKM','PKO','PKP','PKQ','PKT','PKS','SSYR','SSYH','SKPRMB','KPM','WVW','SEA','SEB','SEC','S9M','S9H','XKS','SYI','SNI','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','LGA','SLY','SLS','SLE','SLF','SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','TP','TH','TR','AC1','AC2','ACH','ACH1','ACH2','ACH3','AC3','AC4','ACH4','ACH5','ACH6','AC7','HT1','HT2','HT3','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAA','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAK','KAJ','KBF','XKM','XKH','VKH','VKD','FJM','SAZM','FFM','21M','21A','LLKH','LHHR','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','VVY','RG1','RG2','RG3','RG5','RG6','RG7','PPS','PPJ','TS1','TS2','TS3','TS4','DS1','DS2','PK','P11','P12','P13','P14','P15','P16','P17','P18','P19','P22','CTH','CTV','CTM')
	AND DisableLiveCasino <> DisableGoldDeluxe
	
select * from #tmpEnableAgent
GO
----------------------------------------------------------------------------------------------

	
--step 1: DEPLOY THIS sp on DBCUST/CUSTDB
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@custid INT		
	,@roleid INT
	,@DisableGoldDeluxe BIT
	,@target VARCHAR(30)		
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo')) <> 1
		RETURN
	
	IF @roleid = 2
	BEGIN
		UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
		SET DisableGoldDeluxe = @DisableGoldDeluxe
		WHERE recommend = @custid
	END
	ELSE IF @roleid = 3
	BEGIN
		UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
		SET DisableGoldDeluxe = @DisableGoldDeluxe
		WHERE mrecommend = @custid
	END
	ELSE IF @roleid = 4
	BEGIN
		UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
		SET DisableGoldDeluxe = @DisableGoldDeluxe
		WHERE srecommend = @custid
	END
			
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
SELECT custid, roleid, DisableLivecasino as Disable, 0 as isfinished
INTO #tmpAdjustAgent
FROM custifno WITH(NOLOCK)
WHERE USEname IN ('M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','S359HL','S359RM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAE','DAF','HX','DAM','HN','HQ','TKRM','WBRMB','WBR','WBRR','WBRA','wbrf','WBRG','WBRH','WBRI','WBRJ','TG1','TG3','TG2','TG4','CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T','B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T','B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','SKKM','ywrm','6599RM','SALR','SALH','MALM','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM','TED','THH','THS','TEG','THT','MAMRM','SMAMRMB','SAMR','M25RM','M25ARMB','M25BRMB','S25R','M25HK','S25RM','L25RM','MMYBRM','MMYBH','BYS','MBY','BYM','BYU','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IK','IJ','AN','WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA','AQ','AD','WJ','WG','HI','BI','BJ','LI','LW','UI','II','IA','IE','IG','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','AW','AG','AF','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM','AL','DB','SD','CJEU','M26RMB','M26ARMB','M26RM','M26SD','M26BRMB','M26ARM','S26H','M26BRM','M252RMB','M252H','SCHK','SCM','SCS','SCSM','SCH','SCAH','SCAI','SCI','SCBH','SCHI','SCDH','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69BP','S69HD','S69RP','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK','S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II','S56UH','S56VH','S56A','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','HK07','S56ASD','HK09','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','S36RMB','S36RM','SD1R','s79rrr','S79RM','S79AR','S79R','S79H','S79AHH','S79HH','S79HK','S799H','S79SH','M79H','S79HG','S79hz','S79CR','S79HS','S79I','S79C','WD1','WD2','WD3','S79RMB','M79U','WDD','WDE','WDH','WDI','WDJ','WDK','WDL','M79V','WDR','WD','WC','WD7','S49RM','S49R','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S60RUP','S60AR','D60','E60','S16RUP','6666HK','6666BP','6666US','6666EU','M6HK','6hk6601','M6SD','6666AUD','S6EU','S6RUP','S6US','S6ARUP','M6RM','AA','BA','6666AHK','DA','6666AEU','MPH','JPG','S6H','FA','VC','S6BP','VD','VM','VF','GA','VO','GG','s6cn','VP','VQ','S6HK','S6RMB','FM','S6P','VI','VE','VA','VG','MD','S9EU','S6T','VJ','S6S','S6AHK','S88D','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEM','SEI','SEH','SED','SEK','SEMA','MJRMB','SJM','SJH','SJSD','SBHK','S305CRMB','S305RM','S31RM','S31RMB','S305R','S31ARMB','SSFH','SSF1H','S3H','SSF2H','SSF3H','MSFR','SSFK','S3HH','SSF5H','S31BRM','S3HK','S305M','S3HG','S3HJ','S3HP','SSF6H','SHSD','SHRMB','SHTB','SHHK','hhm','SHKK','SHHT','SHDK','SHHK1','SHHK2','SHR','SHR1','SHHK3','SHI','shhk5','SHR3','shhk6','SHR5','SHHK7','hhma','sh8','SHHK9','HHN','SHHK8','HHK1','HHK10','HHK2','HHK3','HHR','HHK4','BHJ','CFT','TT','TTA','TTB','S2R','S2T','S2AR','S2BR','S2TB','S688R','S688H','S788H','S688T','S688AH','S688M','LP','LLP','LLR','A68US','A688U','SAKH','SAKM','DKE','DKD','M8H','SWU','SWK','SWM','S2H','S2M','S2HH','S2MM','S2MN','S2HY','MRTB','MKWRM','SRRMB','SKWRMB','SRARMB','SRRH','SRR','SRH','SRHK','SRRR','SRMA','SRHKA','SRJ','SRKH','SRHH','SRMB','SRK','SRHC','SRHD','SRMC','SRQ','SMQARMB','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK','S99HKK','S99HKD','S99BH','S99TH','S99RMB','S999TB','S99C','S99THB','S99D','S99MHK','S99CH','S99BT','S99HA','S99TC','S99E','S99BA','S99BB','S99BC','S99BD','WKH','S45H','s45m','S45AH','S45BH','S45AM','S45BM','S45HK','KJH','KJHB','KJM','KJI','KJD','KJT','KJMB','KJK','KJE','KJB','KJC','KJF','KJMC','KJMA','KJG','KJMD','KJL','KJO','KJME','KJMF','AHM','AHN','AHI','AHO','BHO','AHP','AHQ','AHR','BHN','AHH','AHE','bhu','AHF','AHD','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2','GMG','BKK','S41S','S41M','S41H','S43S','S43H','S41K','MC','MC1','MC2','MCR','MC3','MC5','LJ','LH','LU','LY','LL','LB','LC','LD','LE','LV','LF','LT','KD','KL','HA','LS','LA','LG','LM','LII','LZ','BGR','CHU','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPI','HPZ','HPR','HPJ','HPH','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPE','HPA','MO','MP','HPG','HPB','HPF','HPL','SX5','MQ','SX6','HP2','MG','SX7','SX8','HTB','HPS','HPM2','HP1','HPT','HP3','SX9','HSS','HMN','SATU','SATE','SATS','SATM','JS','JS1','JM','JS2','SFH','JS3','JS5','JS6','JS7','JS8','SJS','SFHA','JS9','JSA','JSC','JSB','JSD','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSH','JSK','JSL','JSM','JR','JSZ','SHG','JSN','JSP','JSU','JRA','JSV','JSW','JSX','JSY','JTH','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHH','JHJ','SAS','ASA','SAE','SAI','ASB','M71RMB','M71ARMB','M71BRMB','M71CRMB','S71RM','M71DRMB','SER','S71H','S71AH','S71M','S71BH','S71MA','S71CH','S71DH','S71MB','SCLH','SCLM','SMT','SBTM','SBTH','SBTK','SBTN','SBTD','SBTL','SBTR','SBTY','SKHH','SKMM','PKK','PKA','PKB','PKRM','PKID','PKC','PKD','PKE','PKF','MPKS','PKG','PKH','PKJ','PKL','PKM','PKO','PKP','PKQ','PKT','PKS','SSYR','SSYH','SKPRMB','KPM','WVW','SEA','SEB','SEC','S9M','S9H','XKS','SYI','SNI','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','LGA','SLY','SLS','SLE','SLF','SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','TP','TH','TR','AC1','AC2','ACH','ACH1','ACH2','ACH3','AC3','AC4','ACH4','ACH5','ACH6','AC7','HT1','HT2','HT3','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAA','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAK','KAJ','KBF','XKM','XKH','VKH','VKD','FJM','SAZM','FFM','21M','21A','LLKH','LHHR','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','VVY','RG1','RG2','RG3','RG5','RG6','RG7','PPS','PPJ','TS1','TS2','TS3','TS4','DS1','DS2','PK','P11','P12','P13','P14','P15','P16','P17','P18','P19','P22','CTH','CTV','CTM')
	AND DisableLiveCasino <> DisableGoldDeluxe
	
	
DECLARE @custid int, @roleid INT, @disableGoldDeluxe BIT
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tmpAdjustAgent
	SET isfinished = 1
		,@custid = custid
		,@roleid = roleid				
		,@DisableGoldDeluxe = Disable
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @custid = @custid			
			,@roleid = @roleid
			,@DisableGoldDeluxe = @DisableGoldDeluxe
			,@target = 'REPLICATED'
				
	waitfor delay '00:00:0.280'
END			
GO
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
-----------------------------------------------------------------------------------
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
SELECT custid, roleid, DisableLivecasino as Disable, 0 as isfinished
INTO #tmpAdjustAgent
FROM custifno WITH(NOLOCK)
WHERE USEname IN ('M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','S359HL','S359RM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAE','DAF','HX','DAM','HN','HQ','TKRM','WBRMB','WBR','WBRR','WBRA','wbrf','WBRG','WBRH','WBRI','WBRJ','TG1','TG3','TG2','TG4','CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T','B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T','B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','SKKM','ywrm','6599RM','SALR','SALH','MALM','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM','TED','THH','THS','TEG','THT','MAMRM','SMAMRMB','SAMR','M25RM','M25ARMB','M25BRMB','S25R','M25HK','S25RM','L25RM','MMYBRM','MMYBH','BYS','MBY','BYM','BYU','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IK','IJ','AN','WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA','AQ','AD','WJ','WG','HI','BI','BJ','LI','LW','UI','II','IA','IE','IG','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','AW','AG','AF','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM','AL','DB','SD','CJEU','M26RMB','M26ARMB','M26RM','M26SD','M26BRMB','M26ARM','S26H','M26BRM','M252RMB','M252H','SCHK','SCM','SCS','SCSM','SCH','SCAH','SCAI','SCI','SCBH','SCHI','SCDH','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69BP','S69HD','S69RP','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK','S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II','S56UH','S56VH','S56A','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','HK07','S56ASD','HK09','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','S36RMB','S36RM','SD1R','s79rrr','S79RM','S79AR','S79R','S79H','S79AHH','S79HH','S79HK','S799H','S79SH','M79H','S79HG','S79hz','S79CR','S79HS','S79I','S79C','WD1','WD2','WD3','S79RMB','M79U','WDD','WDE','WDH','WDI','WDJ','WDK','WDL','M79V','WDR','WD','WC','WD7','S49RM','S49R','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S60RUP','S60AR','D60','E60','S16RUP','6666HK','6666BP','6666US','6666EU','M6HK','6hk6601','M6SD','6666AUD','S6EU','S6RUP','S6US','S6ARUP','M6RM','AA','BA','6666AHK','DA','6666AEU','MPH','JPG','S6H','FA','VC','S6BP','VD','VM','VF','GA','VO','GG','s6cn','VP','VQ','S6HK','S6RMB','FM','S6P','VI','VE','VA','VG','MD','S9EU','S6T','VJ','S6S','S6AHK','S88D','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEM','SEI','SEH','SED','SEK','SEMA','MJRMB','SJM','SJH','SJSD','SBHK','S305CRMB','S305RM','S31RM','S31RMB','S305R','S31ARMB','SSFH','SSF1H','S3H','SSF2H','SSF3H','MSFR','SSFK','S3HH','SSF5H','S31BRM','S3HK','S305M','S3HG','S3HJ','S3HP','SSF6H','SHSD','SHRMB','SHTB','SHHK','hhm','SHKK','SHHT','SHDK','SHHK1','SHHK2','SHR','SHR1','SHHK3','SHI','shhk5','SHR3','shhk6','SHR5','SHHK7','hhma','sh8','SHHK9','HHN','SHHK8','HHK1','HHK10','HHK2','HHK3','HHR','HHK4','BHJ','CFT','TT','TTA','TTB','S2R','S2T','S2AR','S2BR','S2TB','S688R','S688H','S788H','S688T','S688AH','S688M','LP','LLP','LLR','A68US','A688U','SAKH','SAKM','DKE','DKD','M8H','SWU','SWK','SWM','S2H','S2M','S2HH','S2MM','S2MN','S2HY','MRTB','MKWRM','SRRMB','SKWRMB','SRARMB','SRRH','SRR','SRH','SRHK','SRRR','SRMA','SRHKA','SRJ','SRKH','SRHH','SRMB','SRK','SRHC','SRHD','SRMC','SRQ','SMQARMB','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK','S99HKK','S99HKD','S99BH','S99TH','S99RMB','S999TB','S99C','S99THB','S99D','S99MHK','S99CH','S99BT','S99HA','S99TC','S99E','S99BA','S99BB','S99BC','S99BD','WKH','S45H','s45m','S45AH','S45BH','S45AM','S45BM','S45HK','KJH','KJHB','KJM','KJI','KJD','KJT','KJMB','KJK','KJE','KJB','KJC','KJF','KJMC','KJMA','KJG','KJMD','KJL','KJO','KJME','KJMF','AHM','AHN','AHI','AHO','BHO','AHP','AHQ','AHR','BHN','AHH','AHE','bhu','AHF','AHD','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2','GMG','BKK','S41S','S41M','S41H','S43S','S43H','S41K','MC','MC1','MC2','MCR','MC3','MC5','LJ','LH','LU','LY','LL','LB','LC','LD','LE','LV','LF','LT','KD','KL','HA','LS','LA','LG','LM','LII','LZ','BGR','CHU','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPI','HPZ','HPR','HPJ','HPH','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPE','HPA','MO','MP','HPG','HPB','HPF','HPL','SX5','MQ','SX6','HP2','MG','SX7','SX8','HTB','HPS','HPM2','HP1','HPT','HP3','SX9','HSS','HMN','SATU','SATE','SATS','SATM','JS','JS1','JM','JS2','SFH','JS3','JS5','JS6','JS7','JS8','SJS','SFHA','JS9','JSA','JSC','JSB','JSD','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSH','JSK','JSL','JSM','JR','JSZ','SHG','JSN','JSP','JSU','JRA','JSV','JSW','JSX','JSY','JTH','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHH','JHJ','SAS','ASA','SAE','SAI','ASB','M71RMB','M71ARMB','M71BRMB','M71CRMB','S71RM','M71DRMB','SER','S71H','S71AH','S71M','S71BH','S71MA','S71CH','S71DH','S71MB','SCLH','SCLM','SMT','SBTM','SBTH','SBTK','SBTN','SBTD','SBTL','SBTR','SBTY','SKHH','SKMM','PKK','PKA','PKB','PKRM','PKID','PKC','PKD','PKE','PKF','MPKS','PKG','PKH','PKJ','PKL','PKM','PKO','PKP','PKQ','PKT','PKS','SSYR','SSYH','SKPRMB','KPM','WVW','SEA','SEB','SEC','S9M','S9H','XKS','SYI','SNI','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','LGA','SLY','SLS','SLE','SLF','SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','TP','TH','TR','AC1','AC2','ACH','ACH1','ACH2','ACH3','AC3','AC4','ACH4','ACH5','ACH6','AC7','HT1','HT2','HT3','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAA','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAK','KAJ','KBF','XKM','XKH','VKH','VKD','FJM','SAZM','FFM','21M','21A','LLKH','LHHR','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','VVY','RG1','RG2','RG3','RG5','RG6','RG7','PPS','PPJ','TS1','TS2','TS3','TS4','DS1','DS2','PK','P11','P12','P13','P14','P15','P16','P17','P18','P19','P22','CTH','CTV','CTM')
	AND DisableLiveCasino <> DisableGoldDeluxe
	
	
DECLARE @custid int, @roleid INT, @disableGoldDeluxe BIT
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #tmpAdjustAgent
	SET isfinished = 1
		,@custid = custid
		,@roleid = roleid				
		,@DisableGoldDeluxe = Disable
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @custid = @custid			
			,@roleid = @roleid
			,@DisableGoldDeluxe = @DisableGoldDeluxe
			,@target = 'DBCUST'
				
	waitfor delay '00:00:0.280'
END			

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
 	