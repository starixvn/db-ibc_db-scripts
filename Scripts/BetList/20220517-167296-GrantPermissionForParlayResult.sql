/*<info serverAlias="DBARC-bodb_Archive"></info>*/
/*
	Created : 20220517@Razor
	DB: DBARC-bodb_Archive
	Task: GRANT PERMISSION on Result parlay [RedmineID: #167296]
*/

USE [bodb_Archive]
GO

GRANT	SELECT	ON	match_remark	TO	bodbAdminNet
GRANT	SELECT	ON	match_remark	TO	bodbDownlineNetView
GRANT	SELECT	ON	match_remark	TO	bodbDownlineNet

GRANT	SELECT	ON	ResultDetail_BK	TO	bodbAdminNet
GRANT	SELECT	ON	ResultDetail_BK	TO	bodbDownlineNetView
GRANT	SELECT	ON	ResultDetail_BK	TO	bodbDownlineNet

GRANT	SELECT	ON	ResultDetailOS_bk	TO	bodbAdminNet
GRANT	SELECT	ON	ResultDetailOS_bk	TO	bodbDownlineNetView
GRANT	SELECT	ON	ResultDetailOS_bk	TO	bodbDownlineNet

GRANT	SELECT	ON	ResultDetailES_bk	TO	bodbAdminNet
GRANT	SELECT	ON	ResultDetailES_bk	TO	bodbDownlineNetView
GRANT	SELECT	ON	ResultDetailES_bk	TO	bodbDownlineNet

GRANT	SELECT	ON	ResultDetail3rd_BK	TO	bodbAdminNet
GRANT	SELECT	ON	ResultDetail3rd_BK	TO	bodbDownlineNetView
GRANT	SELECT	ON	ResultDetail3rd_BK	TO	bodbDownlineNet

GO