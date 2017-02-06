/*
	Created: Winnie
	Task: Force minPT for new customer [RedmineID: 69825]
	DB: DBCUST/CustDB
	Date: 20170116
*/ 
		
DECLARE @maxcustid INT
DECLARE @Sporttype INT
SELECT @Sporttype=219	
SELECT @maxcustid = xxx
	
CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,MinPT TINYINT)
INSERT INTO #tempcusts(custid,roleId,MinPT)

SELECT custid,roleid,NULL
FROM Customer WITH(NOLOCK) WHERE username IN ('S222R','S222HK','S222AH','S222BH','S222CH','S222DH','2EH','S222FH','S222GH','2KH','S222MH','2AH','2BH','2CH','2DH','2LH','2MH','2NH','2PH','2MM'
,'2YH','2FH','2GH','2MN','2WH','S222JH','2HH','2RM','2NN','2HK','2RR','2JH','S222N','S222ZH','2XX','2WW','2RH','2IH','2QH','2OH','2SH','2AA','2AB','2MP','2HA','2MY','2MQ','2UH','2HB'
,'MKWRM','SRRMB','SKWRMB','SRARMB','SRH','SRHK','SRMA','SRHKA','SRJ','SRKH','SRHH','SRK','SRHD','SRMC','SRQ','SRHC'
,'KKM','KKH','KKMA','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAB','KGK','KGL','KGM','KGN'
,'SRS','KAD','KGA','KGB','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAJ','KAK','KBG','KBH','KBJ','KBK','KBU','KBL','KBV','KBW','KAI'	
,'HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','HG81','HG29','HA8','H39','HGA','H7','HG3','HGB','HG5'	
,'D77','D78','D79','D80','D81','D82','D83','D85','D66','DRN','DRP','BB1','D96','BB9'
,'TS1','TS2','TS3','TS4','TS5','TS6','D99','DRM'
,'JBK','JBM','JBJ')

UPDATE  t
SET MinPT=cs.SuperPT
FROM #tempcusts t
INNER JOIN [dbo].CustPTSetting3rd_Agent cs WITH(NOLOCK) ON t.custid=cs.CustID 
WHERE roleId=4 AND SportType=@Sporttype

UPDATE  t
SET MinPT=cs.MasterPT
FROM #tempcusts t
INNER JOIN [dbo].CustPTSetting3rd_Agent cs WITH(NOLOCK) ON t.custid=cs.CustID 
WHERE roleId=3 AND SportType=@Sporttype


UPDATE  m
SET SuperPT=t.MinPT
FROM #tempcusts t
INNER JOIN custInfo c WITH(NOLOCK) ON t.custid=c.srecommend 
INNER JOIN CustPTSetting3rd_Member m WITH(ROWLOCK,UPDLOCK) ON c.custid=m.CustID
WHERE t.roleId=4 AND SportType=@Sporttype AND m. CustID>@maxcustid


UPDATE  m
SET MasterPT=t.MinPT
FROM #tempcusts t
INNER JOIN custInfo c WITH(NOLOCK) ON t.custid=c.mrecommend 
INNER JOIN CustPTSetting3rd_Member m WITH(ROWLOCK,UPDLOCK) ON c.custid=m.CustID
WHERE t.roleId=3 AND SportType=@Sporttype AND m. CustID>@maxcustid

drop table #tempcusts
		
