/*
 Offer NG for VWIN to upline with bet limit as below:
 https://redmine.nexcel.vn/issues/9634

ID	Currency	minbet	maxbet	maxpermatch		max per ball
2	MYR			1		5000	25000			15000
3	USD			1		150		8000			500
4	THB			10		50000	250000			150000
13	RMB			1		10000	50000			30000
15	IDR			5		15000	72000			43000
20	UUS			1		10000	50000			30000
51	VND			10		33000	160000			100000

*/

ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
    @custid INT,   
    @currency INT,
    @site varchar (20),
    @whatAreYouDoing varchar(100) = ''
AS
SET NOCOUNT ON

if @whatAreYouDoing <> 'Offer_VWIN_NG_setting' RETURN --:D

DECLARE @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY, @maxperball MONEY, @ptVALUE SMALLMONEY
SELECT  @ptVALUE = 0.85
SELECT @minbet = CASE
               WHEN @currency = 2  and @site = 'VWIN' THEN 1  --RM/MYR
			   WHEN @currency = 3  and @site = 'VWIN' THEN 1  --USD
			   WHEN @currency = 4  and @site = 'VWIN' THEN 10  --TB/THB
			   WHEN @currency = 13 and @site = 'VWIN' THEN 1  --RMB/CNY
			   WHEN @currency = 15 and @site = 'VWIN' THEN 5 --IN
			   WHEN @currency = 20 and @site = 'VWIN' THEN 1  --UUS
			   WHEN @currency = 51 and @site = 'VWIN' THEN 10  --INH
			   ELSE 0 END,
          
        @maxbet = CASE
               WHEN @currency = 2  and @site = 'VWIN' THEN 5000  --RM/MYR
			   WHEN @currency = 3  and @site = 'VWIN' THEN 150  --USD
			   WHEN @currency = 4  and @site = 'VWIN' THEN 50000  --TB/THB
			   WHEN @currency = 13 and @site = 'VWIN' THEN 10000  --RMB/CNY
			   WHEN @currency = 15 and @site = 'VWIN' THEN 15000 --IN
			   WHEN @currency = 20 and @site = 'VWIN' THEN 10000  --UUS
			   WHEN @currency = 51 and @site = 'VWIN' THEN 33000  --INH
			   ELSE 0 END,

		@maxperball = CASE
               WHEN @currency = 2  and @site = 'VWIN' THEN 15000  --RM/MYR
			   WHEN @currency = 3  and @site = 'VWIN' THEN 500  --USD
			   WHEN @currency = 4  and @site = 'VWIN' THEN 150000  --TB/THB
			   WHEN @currency = 13 and @site = 'VWIN' THEN 30000  --RMB/CNY
			   WHEN @currency = 15 and @site = 'VWIN' THEN 43000 --IN
			   WHEN @currency = 20 and @site = 'VWIN' THEN 30000  --UUS
			   WHEN @currency = 51 and @site = 'VWIN' THEN 100000  --INH
			   ELSE 0 END,
				 
         @maxpermatch = CASE
               WHEN @currency = 2  and @site = 'VWIN' THEN 25000  --RM/MYR
			   WHEN @currency = 3  and @site = 'VWIN' THEN 8000  --USD
			   WHEN @currency = 4  and @site = 'VWIN' THEN 250000  --TB/THB
			   WHEN @currency = 13 and @site = 'VWIN' THEN 50000  --RMB/CNY
			   WHEN @currency = 15 and @site = 'VWIN' THEN 72000 --IN
			   WHEN @currency = 20 and @site = 'VWIN' THEN 50000  --UUS
			   WHEN @currency = 51 and @site = 'VWIN' THEN 160000  --INH
			   ELSE 0 END

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Custinfo') RETURN
 
UPDATE Custinfo WITH(rowlock, updlock)
SET maxperball161 = @maxperball,
	maxpermatch161 = @maxpermatch,
	disablenumber = 0
WHERE srecommend = @custid
     and roleid in (2,3,4)
	

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting3rd') RETURN
--UPDATE AT SUPER LEVEL
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET minbet = @minbet, 
	maxbet = @maxbet,
	apositiontaking = @ptVALUE,
    mpositiontaking = @ptVALUE,
    spositiontaking = @ptVALUE    
WHERE CustID = @custid
      AND sporttype = 161
      AND bettype BETWEEN 81 AND 90

--UPDATE AT MASTER LEVEL
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET minbet = @minbet, 
	maxbet = @maxbet,
	apositiontaking = 0,
	mpositiontaking = @ptVALUE,
    spositiontaking = 0 
WHERE sporttype = 161
      AND bettype BETWEEN 81 AND 90
      AND custid IN (SELECT custid FROM custinfo(nolock) WHERE srecommend = @custid AND roleid = 3)  
      
--UPDATE AT AGENT LEVEL
UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET minbet = @minbet, 
	maxbet = @maxbet,
	apositiontaking = @ptVALUE,
	mpositiontaking = 0,
    spositiontaking = 0
WHERE sporttype = 161
      AND bettype BETWEEN 81 AND 90
      AND custid IN (SELECT custid FROM custinfo(nolock) WHERE srecommend = @custid AND roleid = 2)  

GO
----------------------------
----------------------------

CREATE TABLE #list (custid INT PRIMARY KEY, currency INT, isdone BIT, username VARCHAR(50), [site] varchar(20))

INSERT INTO #list (custid, currency, isdone, username, [site])
SELECT custid, currency, 0, username,[site]
FROM dep_custsuper WITH(NOLOCK)
WHERE (site = 'VWIN' and currency IN (2,3,4,13,15,51,20))

DECLARE @custid INT, @currency INT, @username VARCHAR(50), @site VARCHAR (20)

WHILE (1=1)
BEGIN
    UPDATE TOP (1) #list
    SET @custid = custid,
        @currency = currency,
        @username = username,        
        @site = [site],
        isdone = 1
    WHERE isdone = 0
   
    IF @@ROWCOUNT = 0 BREAK
 
    EXEC dbo.Acc_ExecRep_09 
		@custid = @custid,
		@currency = @currency,
		@site = @site,
		@whatAreYouDoing = 'Offer_VWIN_NG_setting' 
		
    PRINT @username
END

DROP TABLE #list
