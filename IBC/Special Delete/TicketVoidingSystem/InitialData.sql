/*
	Created: 20190122@Kathy
	DB: DBTXN.bodb02
	Task: initial data [Redmine:#90155]
*/

USE [bodb02]
GO
SET IDENTITY_INSERT [dbo].[TicketVoiding_Action] ON 

GO
INSERT [dbo].[TicketVoiding_Action] ([ActionId], [ActionName]) VALUES (1, N'Void')
GO
INSERT [dbo].[TicketVoiding_Action] ([ActionId], [ActionName]) VALUES (2, N'Take note')
GO
INSERT [dbo].[TicketVoiding_Action] ([ActionId], [ActionName]) VALUES (3, N'Waiting')
GO
SET IDENTITY_INSERT [dbo].[TicketVoiding_Action] OFF
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (0, 12, N'Event Early Start', N'由於賽事時間提前開始')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (0, 13, N'Event Early Start', N'由於賽事時間提前開始')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (0, 14, N'Wrong Event Start Time', N'由于开赛时间显示有误')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (1, 12, N'Early Kick Off', N'由于赛事时间提前开始')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (1, 13, N'Early Kick Off', N'由于赛事时间提前开始')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (1, 14, N'Wrong Kick Off Time', N'由于开赛时间显示有误')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (2, 12, N'Early Tip Off', N'由于赛事时间提前开始')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (2, 13, N'Early Tip Off', N'由于赛事时间提前开始')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (2, 14, N'Wrong Tip Off Time', N'由于开赛时间显示有误')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (10, 12, N'Event Early Tee Off', N'由于赛事时间提前开始')
GO
INSERT [dbo].[TicketVoiding_ReasonTemplate] ([Sporttype], [SubIssueTypeId], [ReasonEnglish], [ReasonChineseSimplified]) VALUES (10, 13, N'Event Early Tee Off', N'由于赛事时间提前开始')
GO
