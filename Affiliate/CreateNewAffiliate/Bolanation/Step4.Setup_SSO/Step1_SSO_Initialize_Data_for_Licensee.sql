/*
	Creator: 20151126@Victor 
	Remark: script to initiate setting for a new Licensee to use SSO on Affiliate Admin system
	DB: DBLIC
*/

USE bodb_licensee
GO

DECLARE @AdminName		VARCHAR(50) = 'pgmPeter'
DECLARE @LicenseeName VARCHAR(50) = 'Bolanation'

DECLARE @AdminID INT 
DECLARE @LicenseeID INT

SELECT @AdminID = UserID FROM bodb_licensee.dbo.Users WITH (NOLOCK) WHERE username LIKE @AdminName
SELECT @LicenseeID = LicenseeID FROM bodb_licensee.dbo.Licensees WHERE LicenseeName LIKE @LicenseeName 

--1. Add Licensee's default Group to Aff_GroupInfo
INSERT INTO Aff_GroupInfo (LicenseeID, GroupName, GroupDesc, CreateDate, ModifyDate, DisplayOrder, Creator)
SELECT @LicenseeID,  'Administrator', 'Administrator Group', GETDATE(), GETDATE(),  5, @AdminID
UNION
SELECT @LicenseeID,  'Aff_IT_Dept', 'IT dept', GETDATE(), GETDATE(),  2, @AdminID
UNION
SELECT @LicenseeID,  'None', 'None', GETDATE(), GETDATE(),  1, @AdminID
UNION
SELECT @LicenseeID,  'Marketing', 'Marketing Dept', GETDATE(), GETDATE(),  3, @AdminID
UNION
SELECT @LicenseeID,  'Finance', 'Finance Group', GETDATE(), GETDATE(),  4, @AdminID
UNION
SELECT @LicenseeID,  'CSD', 'CSD', GETDATE(), GETDATE(),  5, @AdminID

/*
INSERT INTO Aff_FunctionInfo(FunctionName, FunctionNote, FunctionDesc, FunctionRender, CreateDate, ModifyDate, DisplayOrder, Creator, ParentID, Filenames)
SELECT '[UserControl]','','User Management',3,GETDATE(),GETDATE(),1, @AdminID, 0,'UserControl/ListUser.aspx; UserControl/EditUser.aspx; UserControl/AddUser.aspx; UserControl/AddUserExist.aspx; UserControl/ListDepartment.aspx; UserControl/AddDepartment.aspx; UserControl/EditDepartment.aspx;UserControl/EditAdminPolicy.aspx; UserControl/EditGroupPolicy.aspx; UserControl/ListUserInDept.aspx; UserControl/UpdateMultiAdmins.aspx'
UNION
SELECT '[Affiliate]','','Affiliate',3,GETDATE(),GETDATE(),1, @AdminID, 0,'UserInfo/AffiliateList.aspx; UserInfo/AffiliateUpd.aspx; UserInfo/AccOverview.aspx; UserInfo/MemberList.aspx; DailyEarning.aspx; DailyEarningDetail.aspx; EarningsHistory.aspx; MemberList.aspx; PlayersDetail.aspx; StatementUpd.aspx; Customer/AffDefault.aspx; Customer/Statistics.aspx; Customer/AffiliateInfo.aspx; UserInfo/MediaStatistics.aspx; UserInfo/note.aspx; Others/EmailHistory.aspx; Others/ViewEmailDetails.aspx;UserInfo/MemberListAll.aspx;GroupSetting/AssignGroup.aspx;UserInfo/MemberList.aspx;'
UNION
SELECT '[Payment]','','Payment',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Payment/PaymentRequest.aspx; Payment/PaymentUpdate.aspx; Payment/Payment_.aspx'
UNION
SELECT '[Media]','','Marketing Tools',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Media/Listbanner.aspx; Media/AddBanner.aspx'
UNION
SELECT '[AffEx.Rate]','','Currency Rates',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Exchange/AffRate.aspx; Exchange/AffEditRate.aspx'
UNION
SELECT '[HotNews]','','Messages',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Others/Message.aspx'
UNION
SELECT '[CommissionGroup]','','Commission Group',3,GETDATE(),GETDATE(),1, @AdminID, 0,'GroupSetting/GroupSetting.aspx; GroupSetting/AddGroup.aspx; GroupSetting/EditGroup.aspx;'
UNION
SELECT '[AffReport]','','Reports',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Home/Home.aspx;Report/MemberReport.aspx;Report/AffiliateReport.aspx;Report/MemberStaticticsReport.aspx;Report/AffiliateQMReport.aspx'
UNION
SELECT '[Resources]','Resources','Translations',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Resources/Add.aspx;Resources/Update.aspx;Resources/Default.aspx'
UNION
SELECT '[SystemSettings]','Configuration','Configurations',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Settings/Add.aspx;Settings/Update.aspx;Settings/Default.aspx;Settings/Country.aspx;Settings/CountryUpdate.aspx;Settings/Language.aspx;Settings/LanguageUpdate.aspx;Settings/Product.aspx;Settings/ProductUpdate.aspx;Settings/AffType.aspx;Settings/AffTypeUpdate.aspx;Resources/Default.aspx;Resources/Add.aspx;Resources/Update.aspx'
UNION
SELECT '[Domain]','','Domain Control',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Domain/12BetDomain.aspx;Domain/Add12BetDomain.aspx;Domain/AddAffiliateDomain.aspx;Domain/AffiliateDomain.aspx;Domain/DomainControl.aspx;Domain/DomainControlIns.aspx;Domain/DomainControlUpd.aspx;Domain/Edit12BetDomain.aspx;Domain/EditAffiliateDomain.aspx;'
UNION
SELECT '[Country]','Country permission','Country',3,GETDATE(),GETDATE(),1, @AdminID, 0,'Settings/Country.aspx;Settings/CountryUpdate.aspx'
UNION
SELECT '[MonthlyTransfer]','Monthly Transfer','Monthly Transfer',3,GETDATE(),GETDATE(),1, @AdminID, 13,''
*/

--2. Add licensee to Aff_LicenseeInfo
INSERT INTO Aff_LicenseeInfo (LicenseeID, LicenseeName, IsActive)
VALUES (@LicenseeID, @LicenseeName, 1)

--3. Add function list for licensee on Aff_LicenseeFunction
INSERT INTO Aff_LicenseeFunction (LicenseeID, FunctionID, IsActive)
SELECT @LicenseeID, FunctionID, 1 FROM Aff_FunctionInfo WITH (NOLOCK) 

--4. Grant permission to licensee for all current IT Users on Aff_LicenseeUser
;WITH ITUser AS
(
	SELECT DISTINCT lu.UserID 
	FROM Aff_LicenseeUser lu WITH (NOLOCK)
		INNER JOIN Users u WITH (NOLOCK) ON u.UserID = lu.UserID AND u.isInternal = 0
	UNION
	SELECT @AdminID AS UserID
)
INSERT INTO Aff_LicenseeUser ([LicenseeID], [UserID], [GroupID], [IsActive], [ModifyDate], [ModifyBy])
SELECT @LicenseeID, i.UserID, g.GroupID, 1, GETDATE(), @AdminID FROM Aff_GroupInfo g WITH (NOLOCK)
	CROSS JOIN ITUser i
WHERE GroupName LIKE 'Aff_IT_Dept' AND LicenseeID = @LicenseeID

--5. Grant full permission for Administrator & Aff_IT_Dept group on Aff_GroupPolicy
INSERT INTO Aff_GroupPolicy ([GroupID], [FunctionID], [Policy], [CreateDate], ModifyDate, Creator)
SELECT g.GroupID, lf.FunctionID, 3, GETDATE(), GETDATE(), @AdminID
FROM Aff_GroupInfo g WITH (NOLOCK) 
	INNER JOIN Aff_LicenseeFunction lf WITH (NOLOCK) ON lf.LicenseeID = g.LicenseeID AND lf.IsActive = 1
WHERE GroupName IN ('Administrator','Aff_IT_Dept') AND g.LicenseeID = @LicenseeID
ORDER BY 1, 2