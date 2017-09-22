/*
	Created: 20170915@Helen
	Task: SMA Turnover Control - Enhancement requests from phase 2 [RedmineID:75557]
	DB: DBAGE/bodb02
*/
USE bodb02
GO
CREATE TABLE dbo.TOControl_LevelSetting
(
	PercentLevel TINYINT
	, PercentValue TINYINT
	, CONSTRAINT [PK_TOControl_LevelSetting] PRIMARY KEY CLUSTERED ([PercentLevel] ASC) ON [DATA]
) ON [DATA]

GO
ALTER TABLE dbo.TOControl_Transition
ADD IsGroupHeadLine BIT 

GO

ALTER TABLE [dbo].[TOControl_Transition] ADD CONSTRAINT [DF_TOControl_Transition_IsGroupHeadLine] DEFAULT ((0)) FOR [IsGroupHeadLine]

GO