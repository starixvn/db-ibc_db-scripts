Use bodb02
GO 

/*
Task: ReGen Data 2020-04-30 of AG, GD, due to job fail 
DB: DBTXN.bodb02

*/


EXEC dbo.Task_Dep_DailySumData3rdProduct
		@WinlostDate		= '2020-04-30'
		,@ProductIds		= '10,11'

EXEC dbo.Task_Dep_AdjustData3rdProduct
	@WinlostDate		= '2020-04-30'
	,@ProductIds		=  '10,11'
	

------------------------------------------------------
---	#2: Regen Job on DB052/DB053
--2.1
bodb_LicenseeReport: Daily Summary Licensee Winloss
--2.2
bodb_LicenseeReport: DW - Generate Daily 
