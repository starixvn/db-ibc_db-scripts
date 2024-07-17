/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
/*
	Created: 20240718@Lewis
	DB: DBODDSFEED-bodb_OddsFeed
	Task: XML - OTP login - CREATE TABLE AdminUserOTP
*/
USE [bodb_oddsfeed]
GO

CREATE TABLE [dbo].[AdminUserOTP](
	[UserID] [int] NOT NULL,
	[SecretKey] [nvarchar](50) NOT NULL,
	[IsIgnoreOTP] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL
 CONSTRAINT [PK_AdminUserOTP] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA],
) ON [DATA]
GO

ALTER TABLE [dbo].[AdminUserOTP] ADD  CONSTRAINT [DF_Odds_AdminUserOTP_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[AdminUserOTP] ADD  CONSTRAINT [DF_Odds_AdminUserOTP_IsIgnoreOTP]  DEFAULT ((0)) FOR [IsIgnoreOTP]
GO