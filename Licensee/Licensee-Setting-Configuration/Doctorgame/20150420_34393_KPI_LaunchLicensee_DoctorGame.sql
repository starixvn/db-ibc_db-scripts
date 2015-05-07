USE bodb_licensee
GO

--Boping_LC Branch
EXEC dbo.KPI_AddNewGroup @GroupName = 'Doctorgame',
					 @BranchID = 16,
					 @ProductID = 4

--Boping_RNG Branch
EXEC dbo.KPI_AddNewGroup @GroupName = 'Doctorgame',
					 @BranchID = 19,
					 @ProductID = 6
