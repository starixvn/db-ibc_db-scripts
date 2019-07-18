/*
	Task: Create a temporaty table for data initialization - Redmine: 114830
	Creator: Dominic@20190718
	Run at: CustDB@DBCUST 
*/
USE CustDB
GO

CREATE TABLE [dbo].[EsportVR_Temp](
	[VRValue_121] [money] NULL,
	[VRValue_122] [money] NULL,
	[VRValue_123] [money] NULL,
	[VRValue_124] [money] NULL,
	[VRValue_125] [money] NULL,
	[VRValue_126] [money] NULL,
	[VRValue_127] [money] NULL,
	[VRValue_128] [money] NULL,
	[HasSameVR] [bit] NULL,
	[srecommend] [int] NULL,
	[mrecommend] [int] NULL,
	[recommend] [int] NULL,
	[RoleID] [tinyint] NULL,
	[CustID] [int] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[EsportVR_Temp] ADD  DEFAULT ((1)) FOR [HasSameVR]
GO



