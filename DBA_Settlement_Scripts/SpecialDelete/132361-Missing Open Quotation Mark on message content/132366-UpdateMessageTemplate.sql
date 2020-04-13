/*
	Created: 20200413@Max
	Task: Update message template - [Redmine:#132366]
	DB: DBTXN/bodb02
*/

USE bodb02
GO

UPDATE dbo.TicketVoiding_MessageTemplate
	SET MsgEnglish = N'Attn:[{{Sport type}}] Due to wrong market offered on Live betting for match between "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], bet ID: "@@" {{PlacedFromTimeRange}}{{Score}}are considered VOID. Parlay counted as (1). {{CheckStatement}}Sorry for the inconvenience caused!'
		,MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於滾球賽事盤口錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}] , 注單: "@@" {{PlacedFromTimeRange}}{{Score}} 已被作廢. 過關以(1)計算. {{CheckStatement}}不便之處 敬請見諒!'
		,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于滚球赛事盘口错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" {{PlacedFromTimeRange}}{{Score}}已被作废. 过关以(1)计算. {{CheckStatement}}不便之处 敬请见谅!'
		,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于滚球赛事盘口错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" {{PlacedFromTimeRange}}{{Score}}已被作废. 过关以(1)计算. {{CheckStatement}}不便之处 敬请见谅!'
WHERE TemplateId = 35


