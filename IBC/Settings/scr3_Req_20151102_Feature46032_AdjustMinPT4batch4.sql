 /*
	Created: Johnson
	Date: 2015-11-02
	Task: Adjust min pt for customers list requested 4th batch
	DB: DBCUST/CUSTDB
 */
---
-- BEGIN STEP 1: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
 CREATE TABLE ##tmpCust (custid int, isfinished bit default(0))

DECLARE 
	@minpositiontaking_1 smallmoney = 0.5,
    @minpositiontaking_2 smallmoney= 0.5,
    @minpositiontaking_3 smallmoney= 0.5,
    @minpositiontaking_4 smallmoney= 0.5,
    @minpositiontaking_5 smallmoney= 0.5,
    @minpositiontaking_6 smallmoney= 0.5,
    @minpositiontaking_7 smallmoney= 0.5,
    @minpositiontaking_8 smallmoney= 0.5,
    @minpositiontaking_9 smallmoney= 0.5,
    @minpositiontaking_10 smallmoney= 0.5,
    @minpositiontaking_9999 smallmoney = 0.5,
    @minlivepositiontaking_1 smallmoney= 0.5,
    @minlivepositiontaking_3 smallmoney= 0.5,
    @minlivepositiontaking_7 smallmoney= 0.5,
    @minlivepositiontaking_8 smallmoney= 0.5,
    
    @minv2positiontaking_1 smallmoney= 0.5,
    @minv2positiontaking_2 smallmoney= 0.5,
    @minv2positiontaking_3 smallmoney= 0.5,
    @minv2positiontaking_7 smallmoney= 0.5,
    @minv2positiontaking_8 smallmoney= 0.5,    
    @minv2positiontaking_20 smallmoney= 0.5,

    @minv3positiontaking_1 smallmoney= 0.5,
    @minv3positiontaking_2 smallmoney= 0.5,
    @minv3positiontaking_3 smallmoney= 0.5,
    @minv3positiontaking_20 smallmoney= 0.5,

    @minv5positiontaking_1 smallmoney= 0.5,
    @minv5positiontaking_2 smallmoney= 0.5,
    @minv5positiontaking_3 smallmoney= 0.5,
    @minv5positiontaking_20 smallmoney= 0.5,
    @minv5positiontaking_9999 smallmoney = 0.5,

    @minv8positiontaking_1 smallmoney= 0.5,
    @minv8positiontaking_3 smallmoney= 0.5,
    @minv8positiontaking_20 smallmoney= 0.5,

    @minv10positiontaking_1 smallmoney= 0.5,
    @minv10positiontaking_2 smallmoney= 0.5,
    @minv10positiontaking_3 smallmoney= 0.5,
    @minv10positiontaking_20 smallmoney= 0.5,

    @minv11positiontaking_1 smallmoney= 0.5,
    @minv11positiontaking_20 smallmoney= 0.5,

    @minv99positiontaking_1 smallmoney= 0.5,
    @minv99positiontaking_2 smallmoney= 0.5,
    @minv99positiontaking_3 smallmoney= 0.5,
    @minv99positiontaking_9 smallmoney= 0.5,
    @minv99positiontaking_20 smallmoney= 0.5,
    
    @minv154positiontaking_20 smallmoney = 0.5
    
DECLARE @custid INT, @max_custid INT

SELECT @max_custid = xx

--34 customers
INSERT INTO ##tmpCust(custid)
		 select 	174095	--	2	6666AUD
union all select 	1575555	--	4	AA
union all select 	13892822	--	4	AKO1
union all select 	13893053	--	4	AKO2
union all select 	17120967	--	4	AKO3
union all select 	1584509	--	4	BA
union all select 	2078394	--	4	DA
union all select 	4505274	--	4	FA
union all select 	11665608	--	4	FM
union all select 	5969746	--	4	GA
union all select 	8429220	--	4	GG
union all select 	15140611	--	4	KRW
union all select 	947130	--	3	M6RM
union all select 	47030	--	3	M6SD
union all select 	16737515	--	4	MD
union all select 	835418	--	4	S6ARUP
union all select 	9735627	--	4	S6KW
union all select 	549191	--	4	S6RUP
union all select 	17537176	--	4	S6T
union all select 	10910070	--	4	S7KW
union all select 	18015222	--	4	S9KK
union all select 	17583600	--	4	S9KS
union all select 	15530229	--	4	S9KW
union all select 	15424123	--	4	VA
union all select 	4548911	--	4	VC
union all select 	14773243	--	4	VE
union all select 	5957920	--	4	VF
union all select 	15485426	--	4	VG
union all select 	13478477	--	4	VI
union all select 	17916695	--	4	VJ
union all select 	5938255	--	4	VM
union all select 	8284552	--	4	VO
union all select 	9514014	--	4	VP
union all select 	10927694	--	4	VQ

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) ##tmpCust
	SET isfinished = 1
		,@custid = custid				
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @custid = @custid					
			,@target = 'REPLICATED'
			,@minpositiontaking_1 = @minpositiontaking_1
			,@minpositiontaking_2 = @minpositiontaking_2 
			,@minpositiontaking_3 = @minpositiontaking_3
			,@minpositiontaking_4 = @minpositiontaking_4
			,@minpositiontaking_5 = @minpositiontaking_5
			,@minpositiontaking_6 =@minpositiontaking_6
			,@minpositiontaking_7 = @minpositiontaking_7
			,@minpositiontaking_8 = @minpositiontaking_8
			,@minpositiontaking_9 = @minpositiontaking_9
			,@minpositiontaking_10 = @minpositiontaking_10
			,@minpositiontaking_9999 = @minpositiontaking_9999
			,@minlivepositiontaking_1= @minlivepositiontaking_1
			,@minlivepositiontaking_3 = @minlivepositiontaking_3
			,@minlivepositiontaking_7 = @minlivepositiontaking_7
			,@minlivepositiontaking_8 = @minlivepositiontaking_8
		    
			,@minv2positiontaking_1 = @minv2positiontaking_1
			,@minv2positiontaking_2 = @minv2positiontaking_2
			,@minv2positiontaking_3 = @minv2positiontaking_3
			,@minv2positiontaking_7 = @minv2positiontaking_7
			,@minv2positiontaking_8 = @minv2positiontaking_8
			,@minv2positiontaking_20 = @minv2positiontaking_20

			,@minv3positiontaking_1 = @minv3positiontaking_1
			,@minv3positiontaking_2 = @minv3positiontaking_2
			,@minv3positiontaking_3 = @minv3positiontaking_3
			,@minv3positiontaking_20 = @minv3positiontaking_20

			,@minv5positiontaking_1 = @minv5positiontaking_1
			,@minv5positiontaking_2 = @minv5positiontaking_2
			,@minv5positiontaking_3 = @minv5positiontaking_3
			,@minv5positiontaking_20= @minv5positiontaking_20
			,@minv5positiontaking_9999 = @minv5positiontaking_9999
			
			,@minv8positiontaking_1 = @minv8positiontaking_1
			,@minv8positiontaking_3 = @minv8positiontaking_3
			,@minv8positiontaking_20 = @minv8positiontaking_20

			,@minv10positiontaking_1 = @minv10positiontaking_1 
			,@minv10positiontaking_2 =@minv10positiontaking_2
			,@minv10positiontaking_3 = @minv10positiontaking_3 
			,@minv10positiontaking_20 = @minv10positiontaking_20 

			,@minv11positiontaking_1 = @minv11positiontaking_1 
			,@minv11positiontaking_20 =@minv11positiontaking_20 

			,@minv99positiontaking_1 =@minv99positiontaking_1 
			,@minv99positiontaking_2 =@minv99positiontaking_2 
			,@minv99positiontaking_3 =@minv99positiontaking_3 
			,@minv99positiontaking_9 = @minv99positiontaking_9
			,@minv99positiontaking_20 = @minv99positiontaking_20
		    
			,@minv154positiontaking_20 = @minv154positiontaking_20
	
	waitfor delay '00:00:0.280'
END			

 DROP TABLE ##tmpCust
GO		
-- END STEP 1: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------



---
-- BEGIN STEP 2: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE ##tmpCust (custid int, isfinished bit default(0))
DECLARE @custid INT, @max_custid INT

DECLARE 
	@minpositiontaking_1 smallmoney = 0.5,
    @minpositiontaking_2 smallmoney= 0.5,
    @minpositiontaking_3 smallmoney= 0.5,
    @minpositiontaking_4 smallmoney= 0.5,
    @minpositiontaking_5 smallmoney= 0.5,
    @minpositiontaking_6 smallmoney= 0.5,
    @minpositiontaking_7 smallmoney= 0.5,
    @minpositiontaking_8 smallmoney= 0.5,
    @minpositiontaking_9 smallmoney= 0.5,
    @minpositiontaking_10 smallmoney= 0.5,
    @minpositiontaking_9999 smallmoney = 0.5,
    @minlivepositiontaking_1 smallmoney= 0.5,
    @minlivepositiontaking_3 smallmoney= 0.5,
    @minlivepositiontaking_7 smallmoney= 0.5,
    @minlivepositiontaking_8 smallmoney= 0.5,
    
    @minv2positiontaking_1 smallmoney= 0.5,
    @minv2positiontaking_2 smallmoney= 0.5,
    @minv2positiontaking_3 smallmoney= 0.5,
    @minv2positiontaking_7 smallmoney= 0.5,
    @minv2positiontaking_8 smallmoney= 0.5,    
    @minv2positiontaking_20 smallmoney= 0.5,

    @minv3positiontaking_1 smallmoney= 0.5,
    @minv3positiontaking_2 smallmoney= 0.5,
    @minv3positiontaking_3 smallmoney= 0.5,
    @minv3positiontaking_20 smallmoney= 0.5,

    @minv5positiontaking_1 smallmoney= 0.5,
    @minv5positiontaking_2 smallmoney= 0.5,
    @minv5positiontaking_3 smallmoney= 0.5,
    @minv5positiontaking_20 smallmoney= 0.5,
    @minv5positiontaking_9999 smallmoney = 0.5,

    @minv8positiontaking_1 smallmoney= 0.5,
    @minv8positiontaking_3 smallmoney= 0.5,
    @minv8positiontaking_20 smallmoney= 0.5,

    @minv10positiontaking_1 smallmoney= 0.5,
    @minv10positiontaking_2 smallmoney= 0.5,
    @minv10positiontaking_3 smallmoney= 0.5,
    @minv10positiontaking_20 smallmoney= 0.5,

    @minv11positiontaking_1 smallmoney= 0.5,
    @minv11positiontaking_20 smallmoney= 0.5,

    @minv99positiontaking_1 smallmoney= 0.5,
    @minv99positiontaking_2 smallmoney= 0.5,
    @minv99positiontaking_3 smallmoney= 0.5,
    @minv99positiontaking_9 smallmoney= 0.5,
    @minv99positiontaking_20 smallmoney= 0.5,
    
    @minv154positiontaking_20 smallmoney = 0.5
    
SELECT @max_custid = xx

INSERT INTO ##tmpCust(custid)
	
INSERT INTO ##tmpCust(custid)
		 select 	174095	--	2	6666AUD
union all select 	1575555	--	4	AA
union all select 	13892822	--	4	AKO1
union all select 	13893053	--	4	AKO2
union all select 	17120967	--	4	AKO3
union all select 	1584509	--	4	BA
union all select 	2078394	--	4	DA
union all select 	4505274	--	4	FA
union all select 	11665608	--	4	FM
union all select 	5969746	--	4	GA
union all select 	8429220	--	4	GG
union all select 	15140611	--	4	KRW
union all select 	947130	--	3	M6RM
union all select 	47030	--	3	M6SD
union all select 	16737515	--	4	MD
union all select 	835418	--	4	S6ARUP
union all select 	9735627	--	4	S6KW
union all select 	549191	--	4	S6RUP
union all select 	17537176	--	4	S6T
union all select 	10910070	--	4	S7KW
union all select 	18015222	--	4	S9KK
union all select 	17583600	--	4	S9KS
union all select 	15530229	--	4	S9KW
union all select 	15424123	--	4	VA
union all select 	4548911	--	4	VC
union all select 	14773243	--	4	VE
union all select 	5957920	--	4	VF
union all select 	15485426	--	4	VG
union all select 	13478477	--	4	VI
union all select 	17916695	--	4	VJ
union all select 	5938255	--	4	VM
union all select 	8284552	--	4	VO
union all select 	9514014	--	4	VP
union all select 	10927694	--	4	VQ

		

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) ##tmpCust
	SET isfinished = 1
		,@custid = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @custid = @custid			
			,@target = 'DBCUST'
			,@minpositiontaking_1 = @minpositiontaking_1
			,@minpositiontaking_2 = @minpositiontaking_2 
			,@minpositiontaking_3 = @minpositiontaking_3
			,@minpositiontaking_4 = @minpositiontaking_4
			,@minpositiontaking_5 = @minpositiontaking_5
			,@minpositiontaking_6 =@minpositiontaking_6
			,@minpositiontaking_7 = @minpositiontaking_7
			,@minpositiontaking_8 = @minpositiontaking_8
			,@minpositiontaking_9 = @minpositiontaking_9
			,@minpositiontaking_10 = @minpositiontaking_10
			,@minpositiontaking_9999 = @minpositiontaking_9999
			,@minlivepositiontaking_1= @minlivepositiontaking_1
			,@minlivepositiontaking_3 = @minlivepositiontaking_3
			,@minlivepositiontaking_7 = @minlivepositiontaking_7
			,@minlivepositiontaking_8 = @minlivepositiontaking_8
		    
			,@minv2positiontaking_1 = @minv2positiontaking_1
			,@minv2positiontaking_2 = @minv2positiontaking_2
			,@minv2positiontaking_3 = @minv2positiontaking_3
			,@minv2positiontaking_7 = @minv2positiontaking_7
			,@minv2positiontaking_8 = @minv2positiontaking_8
			,@minv2positiontaking_20 = @minv2positiontaking_20

			,@minv3positiontaking_1 = @minv3positiontaking_1
			,@minv3positiontaking_2 = @minv3positiontaking_2
			,@minv3positiontaking_3 = @minv3positiontaking_3
			,@minv3positiontaking_20 = @minv3positiontaking_20

			,@minv5positiontaking_1 = @minv5positiontaking_1
			,@minv5positiontaking_2 = @minv5positiontaking_2
			,@minv5positiontaking_3 = @minv5positiontaking_3
			,@minv5positiontaking_20= @minv5positiontaking_20
			,@minv5positiontaking_9999 = @minv5positiontaking_9999
			
			,@minv8positiontaking_1 = @minv8positiontaking_1
			,@minv8positiontaking_3 = @minv8positiontaking_3
			,@minv8positiontaking_20 = @minv8positiontaking_20

			,@minv10positiontaking_1 = @minv10positiontaking_1 
			,@minv10positiontaking_2 =@minv10positiontaking_2
			,@minv10positiontaking_3 = @minv10positiontaking_3 
			,@minv10positiontaking_20 = @minv10positiontaking_20 

			,@minv11positiontaking_1 = @minv11positiontaking_1 
			,@minv11positiontaking_20 =@minv11positiontaking_20 

			,@minv99positiontaking_1 =@minv99positiontaking_1 
			,@minv99positiontaking_2 =@minv99positiontaking_2 
			,@minv99positiontaking_3 =@minv99positiontaking_3 
			,@minv99positiontaking_9 = @minv99positiontaking_9
			,@minv99positiontaking_20 = @minv99positiontaking_20
		    
			,@minv154positiontaking_20 = @minv154positiontaking_20
	
	waitfor delay '00:00:0.280'
END			

DROP TABLE ##tmpCust
GO		
-- END STEP 2: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
 --END 3rd batch
-----------------------------------
 