USE bodb_licensee
GO
/*
	Author: Florent.Nguyen
	Date: 20150406
	Task : Launch of new licensee MarvelDH	146
			+ Sportsbook, Number Game, Live Casino, RNG Casino, Virtual Sports and BA. ( ONEworks's Licensee)
			+ Launch at : 2015-03-25
	RedmineID: #33579
*/
--Add new Licensee to KPI Report (default template)
DECLARE @MaxDepositNo INT = 0

SELECT @MaxDepositNo = MAX(OrderNo) + 1
FROM KPI_Groups g WITH (NOLOCK)
	INNER JOIN KPI_BranchGroup bg WITH (NOLOCK) ON g.GroupID = bg.GroupID
WHERE BranchID = 3

--Deposit Branch
EXEC KPI_AddNewGroup @GroupName = 'MarvelDH'
	, @BranchID = 3
	, @OrderNo = @MaxDepositNo
	, @IsActive = 1
	, @ProductID = 0
--BA Branch
EXEC KPI_AddNewGroup @GroupName = 'MarvelDH'
	, @BranchID = 5
	, @ProductID = 3
--Deposit_NG Branch
EXEC KPI_AddNewGroup @GroupName = 'MarvelDH'
	, @BranchID = 9
	, @ProductID = 2
--Deposit_VS Branch
EXEC KPI_AddNewGroup @GroupName = 'MarvelDH'
	, @BranchID = 12
	, @ProductID = 5
--Deposit_LC Branch
EXEC KPI_AddNewGroup @GroupName = 'MarvelDH'
	, @BranchID = 14
	, @ProductID = 4
--Deposit_RNG Branch
EXEC KPI_AddNewGroup @GroupName = 'MarvelDH'
	, @BranchID = 17
	, @ProductID = 6