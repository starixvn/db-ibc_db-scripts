ALTER TABLE [dbo].[match_remark]
ADD [Tier] [tinyint] NOT NULL CONSTRAINT [DF_match_remark_Tier]  DEFAULT ('1') WITH VALUES


ALTER TABLE [dbo].[match_remark]
ADD [BestOfMap] [tinyint] NOT NULL CONSTRAINT [DF_match_remark_BestOfMap]  DEFAULT ('1') WITH VALUES


ALTER TABLE [dbo].[match_remark]
ADD [IsStartingSoon] [bit] NOT NULL CONSTRAINT [DF_match_remark_IsStartingSoon]  DEFAULT ('1') WITH VALUES



ALTER TABLE [dbo].[match_remark]
ADD [MoveBO3Down] [bit] NOT NULL CONSTRAINT [DF_match_remark_MoveBO3Down]  DEFAULT ('0') WITH VALUES


ALTER TABLE [dbo].[match_remark]
ADD [ShowLiveScore] [bit] NOT NULL CONSTRAINT [DF_match_remark_ShowLiveScore]  DEFAULT ((0)) WITH VALUES


ALTER TABLE [dbo].[match_remark]
ADD [isFullTime] [bit] NOT NULL CONSTRAINT [DF_match_remark_isFullTime]  DEFAULT ((0)) WITH VALUES



ALTER TABLE [dbo].[match_remark]
ADD [MatchType] [tinyint] NOT NULL CONSTRAINT [DF_match_remark_MatchType]  DEFAULT ((1)) WITH VALUES


ALTER TABLE [dbo].[match_remark]
ADD [GameStatus] [tinyint] NOT NULL CONSTRAINT [DF_match_Remark_GameStatus]  DEFAULT ((0)) WITH VALUES

