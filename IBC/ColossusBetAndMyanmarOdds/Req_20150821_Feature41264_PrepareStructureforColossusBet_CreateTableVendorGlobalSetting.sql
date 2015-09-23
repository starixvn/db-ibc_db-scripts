----DBCUST.CustDB

/****** Object:  Table [dbo].[VendorGlobalSetting]    Script Date: 8/27/2015 3:01:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[VendorGlobalSetting](
	[VendorId] [int] NOT NULL,
	[VName] [varchar](50) NOT NULL,
	[NumberValue] [decimal](19, 8) NULL,
 CONSTRAINT [PK_VendorGlobalSetting] PRIMARY KEY CLUSTERED 
(
	[VendorId] ASC,
	[VName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

SET ANSI_PADDING OFF
GO
