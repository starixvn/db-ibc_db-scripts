USE [SiteConfig]
GO

/*
	Created: 20200225@Hogan
	DB: DBCUST.SiteConfig
	Task: Grant Analytics access permission for all users that have full access permissions to Dashboard: [Redmine ID: #119915]
*/

SET NOCOUNT ON;

DECLARE @UserList TABLE (UserSEQ INT, SiteName VARCHAR(50))
DECLARE @UserGroupList TABLE (UserGroupSEQ INT, SiteName VARCHAR(50))
DECLARE @DashboardFunctionList TABLE (FucntionKey VARCHAR(50))
DECLARE @PerformerTabFunction VARCHAR(50)
DECLARE @TempTable TABLE (SiteName VARCHAR(50), UserSEQ INT, FunctionKey VARCHAR(50))

INSERT INTO @DashboardFunctionList(FucntionKey) 
VALUES	('c_turnover')
		,('c_licWL')
		,('n_reg_customer')
		,('c_online_customer')
		,('n_customer_balance')
		,('n_pending_funds')
		,('n_deposit')
		,('n_withdrawal')
		,('db_per_tab')
SET @PerformerTabFunction = 'db_per_tab'

-- Get list of user groups that need 'db_per_tab' function to full access to the Dashboard
INSERT INTO @UserGroupList (UserGroupSEQ, SiteName)
SELECT UserGroupSEQ, SiteName
FROM GroupFuncPermission gp WITH (NOLOCK)
	INNER JOIN @DashboardFunctionList
			ON FucntionKey = gp.FunctionKey
GROUP BY UserGroupSEQ, SiteName
HAVING COUNT (FunctionKey) = 8 AND COUNT(CASE WHEN FunctionKey = @PerformerTabFunction THEN 1 END) = 0

-- Insert 'db_per_tab' function to group user permission
IF EXISTS (SELECT 1 FROM @UserGroupList) 
BEGIN
   INSERT INTO dbo.GroupFuncPermission
			(UserGroupSEQ
			,FunctionKey
			,SubFunctionKeys
			,SiteName)
	SELECT UserGroupSEQ, @PerformerTabFunction, NULL, SiteName
	FROM @UserGroupList
END

-- Get all user permissions for all user except admin
INSERT INTO @TempTable
SELECT		u.SiteName,
			u.UserSEQ,
			up.FunctionKey
FROM		dbo.Users u WITH (NOLOCK)
			INNER JOIN dbo.UserFuncPermission up WITH (NOLOCK)
			ON u.UserSEQ = up.UserSEQ 
			INNER JOIN @DashboardFunctionList 
			ON FucntionKey = up.FunctionKey
WHERE		u.isAdmin = 0 AND up.IsAllow = 1

-- Get list of users who need 'db_per_tab' function to full access to the Dashboard
INSERT INTO @UserList (UserSEQ, SiteName)
SELECT UserSEQ, SiteName
FROM @TempTable
GROUP BY UserSEQ, SiteName
HAVING COUNT (FunctionKey) = 8 AND COUNT(CASE WHEN FunctionKey = @PerformerTabFunction THEN 1 END) = 0

-- Insert 'db_per_tab' function to user permission
IF EXISTS (SELECT 1 FROM @UserList) 
BEGIN
	INSERT INTO dbo.UserFuncPermission
				(UserSEQ
				,FunctionKey
				,SiteName
				,SystemType
				,IsAllow)
	SELECT UserSEQ, @PerformerTabFunction, SiteName, 3, 1
	FROM @UserList
END